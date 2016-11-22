module Hobby
  class Test
    class Report
      class Exchange
        def initialize outer_exchange, actual_response
          @request, @expected_response = *outer_exchange
          @actual_response = actual_response
        end

        def passed?
          @expected_response == @actual_response
        end

        def failed?
          not passed?
        end
      end
    end
  end
end
