module Hobby
  class Test
    class Exchange
      def initialize hash
        @request = Request.new hash['request']
        @response = Response.new hash['response']
      end
      attr_reader :request, :response
    end
  end
end

require 'hobby/test/exchange/request'
require 'hobby/test/exchange/response'
