class Hobby::Test::Exchange
  class Response
    def initialize excon_response, format: JSON
      @excon_response, @format = excon_response, format
    end
    attr_reader :format

    def body
      @body ||= if format
                  format.load @excon_response.body
                else
                  @excon_response.body
                end
    end

    extend Forwardable
    delegate [:status, :headers] => :@excon_response
  end
end
