module Hobby
  class Test
    class Exchange
      def initialize hash
        @request = Request.new hash['request']
        @asserts = hash['response']&.map do |(key, value)|
          Assert.new key, value, *hash['format']
        end || []
      end
      attr_reader :request, :asserts

      def [] connection
        dup.run_against connection
      end

      def ok?
        asserts.all? &:ok?
      end

      protected
        def run_against connection
          response = connection.public_send request.verb, **request
          @asserts = asserts.map &[response]
          self
        end
    end
  end
end

require 'hobby/test/exchange/request'
require 'hobby/test/exchange/assert'
