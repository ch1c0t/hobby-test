module Hobby
  class Test
    require 'yaml'
    require 'json'
    require 'forwardable'
    require 'ostruct'
    
    require 'to_proc/all'
    require 'include_constants'
    require 'excon'
    
    include_constants from: ToProc
    
    def self.from_file string, **defaults
      new (YAML.load_file string), defaults: defaults
    end
    
    def self.from_string string, **defaults
      new (YAML.load string), defaults: defaults
    end
    
    def initialize array_of_hashes, defaults: {}
      @exchanges = array_of_hashes
        .map(&[defaults, :merge])
        .map(&Exchange)
    end
    
    def [] address
      connection = if address.start_with? 'http'
                     Excon.new address
                   else
                     Excon.new 'unix:///', socket: address
                   end
      env = Env.new connection
    
      Report.new @exchanges.map &[env]
    end
  
    class Env < OpenStruct
      def initialize connection
        super connection: connection, responses: []
      end
      
      def last_response
        responses.last
      end
      
      def uri *all
        "/#{all.join '/'}"
      end
    end
  
    class Report
      def initialize exchanges
        @exchanges = exchanges
      end
      
      def ok?
        @exchanges.all? &:ok?
      end
      
      include Enumerable
      extend Forwardable
      delegate [:each, :[], :size] => :@exchanges
    end
  
    class Template
      def initialize pair
        @key = pair.first.partition('.').last.to_sym
        @string = pair.last
      end
      
      def [] env
        value = env.instance_eval @string
        [@key, value]
      end
    end
  
    class Exchange
      def initialize hash
        verb, params = hash.find &Key[Request::VERBS, :include?]
        @request = Request.new [verb, params, *hash[:format]]
        @asserts = (hash['response']&.map &Assert) || []
      end
      attr_reader :request, :asserts
      
      def [] env
        dup.perform_in env
      end
      
      def ok?
        asserts.all? &:ok?
      end
      
      protected
        def perform_in env
          request.perform_in env
          @asserts = asserts.map &[env.last_response]
          self
        end
    
      class Response
        def initialize excon_response, format:
          @excon_response, @format = excon_response, format
        end
        attr_reader :format
        
        def body
          @body ||= if format
                      format.load @excon_response.body
                    else
                      PlainBody.new @excon_response.body
                    end
        end
        
        class PlainBody < String
          def == expected_response
            eql? expected_response.to_s
          end
        end
        
        extend Forwardable
        delegate [:status, :headers] => :@excon_response
      end
    
      class Assert
        def initialize pair
          key, delimiter, chain = pair[0].partition /\.|\[/
          chain.prepend (delimiter == '[' ? 'self[' : 'self.') unless chain.empty?
        
          @key, @chain, @specified_value = key, chain, pair[1]
        end
        attr_reader :key, :chain, :specified_value, :actual_value
        
        def ok?
          @ok
        end
        
        def [] response
          dup.assert response
        end
        
        protected
          def assert response
            @actual_value = response.public_send key
            compare
            self
          end
        
          def compare
            @ok = chain.empty? ? actual_value == specified_value : compare_chain
          end
        
          def compare_chain
            if chain.end_with? '>', '=', '<'
              actual_value.instance_eval "#{chain}(#{specified_value})"
            else
              (actual_value.instance_eval chain) == specified_value
            end
          end
      end
    
      class Request < OpenStruct
        VERBS = %w[delete get head options patch post put]
        def initialize triple
          @verb, hash, @format = triple
        
          template_fields, regular_fields = hash.partition &Key[:start_with?, 'template.']
          @templates = template_fields.map &Template
        
          super regular_fields.to_h
        end
        attr_reader :verb
        
        def regular_fields
          hash = to_h
        
          if body && @format
            hash[:body] = @format.dump body
          end
        
          hash
        end
        
        def perform_in env
          params = regular_fields.merge @templates.map(&[env]).to_h
          
          excon_response = env.connection.public_send verb, **params
          response = Response.new excon_response, format: @format
          env.responses << response
        end
      end
    end
  end
end