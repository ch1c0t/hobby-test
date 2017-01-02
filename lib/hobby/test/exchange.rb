module Hobby
  class Test
    class Exchange
      include ToProc

      def initialize hash
        @request = Request.new hash.find &Key[Request::VERBS, :include?]
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
    end
  end
end

require 'hobby/test/exchange/request'
require 'hobby/test/exchange/response'
require 'hobby/test/exchange/assert'
require 'hobby/test/template'
