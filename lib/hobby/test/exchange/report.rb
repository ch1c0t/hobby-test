class Hobby::Test::Exchange
  class Report
    def initialize exchange, response
      @expected_response = exchange.response
      @actual_response   = response
    end

    def passed?
      @expected_response == @actual_response
    end
  end
end
