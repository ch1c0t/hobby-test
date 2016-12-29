module Hobby
  class Test
    class Exchange
      def initialize hash
        @request = Request.new hash.find { |key, _|
          Request::VERBS.include? key
        }
        @asserts = (hash['response']&.map &Assert) || []
      end
      attr_reader :request, :asserts

      def [] env
        dup.execute_with env
      end

      def ok?
        asserts.all? &:ok?
      end

      protected
        def execute_with env
          response = env.connection.public_send request.verb, **request
          @asserts = asserts.map &[response]
          self
        end
    end
  end
end

require 'hobby/test/exchange/request'
require 'hobby/test/exchange/assert'
