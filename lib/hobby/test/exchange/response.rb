class Hobby::Test::Exchange
  class Response
    def initialize excon_response, body_serializer:
      @excon_response, @body_serializer = excon_response, body_serializer
    end
    attr_reader :body_serializer

    def [] key
      @serialized ||= JSON.load body
      @serialized[key]
    end

    extend Forwardable
    delegate [:status, :headers, :body] => :@excon_response
  end
end
