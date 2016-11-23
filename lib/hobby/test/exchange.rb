module Hobby
  class Test
    class Exchange
      def initialize hash
        @request = Request.new hash['request']
        @response = Response.new hash['response']
      end
      attr_reader :request, :response

      def [] connection
        response = connection.public_send request.verb, **request
        Report.new self, response
      end
    end
  end
end

require 'hobby/test/exchange/request'
require 'hobby/test/exchange/response'
require 'hobby/test/exchange/report'
