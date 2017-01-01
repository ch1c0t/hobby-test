class Hobby::Test::Exchange
  class Response
    def initialize excon_response, format: JSON
      @excon_response, @format = excon_response, format
    end
    attr_reader :format

    def [] key
      @serialized ||= format.load body
      @serialized[key]
    end

    extend Forwardable
    delegate [:status, :headers, :body] => :@excon_response
  end
end
