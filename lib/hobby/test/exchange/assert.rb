class Hobby::Test::Exchange
  module Assert
    def self.[] pair
      key, delimiter, chain = pair[0].partition /\.|\[/
      chain.prepend (delimiter == '[' ? 'self[' : 'self.') unless chain.empty?
      const_get(key.capitalize).new key, chain, pair[1]
    end

    def initialize key, chain, value
      @key, @chain, @specified_value = key, chain, value
    end

    def ok?
      @ok
    end
    
    def [] response
      dup.assert response
    end

    def compare_chain
      if chain.end_with? '>', '=', '<'
        actual_value.instance_eval "#{chain}(#{specified_value})"
      else
        (actual_value.instance_eval chain) == specified_value
      end
    end

    def assert response
      @actual_value = response.public_send key
      compare
      self
    end

    attr_reader :actual_value, :specified_value, :chain, :key

    class Status
      include Assert

      def compare
        @ok = actual_value == specified_value
      end
    end

    class Headers
      include Assert

      def compare
        @ok = chain.empty? ? actual_value == specified_value : compare_chain
      end
    end

    class Body
      include Assert

      def compare
        @actual_value = begin
                          JSON.parse actual_value
                        rescue JSON::ParserError
                          actual_value
                        end

        @ok = if chain.empty?
                actual_value == specified_value
              else
                compare_chain
              end
      end
    end
  end
end
