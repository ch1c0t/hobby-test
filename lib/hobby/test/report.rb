module Hobby
  class Test
    class Report
      def initialize exchanges, responses
        @exchanges = exchanges.zip(responses).map &Exchange
      end
      attr_reader :exchanges

      def ok?
        exchanges.all? &:passed?
      end

      include Enumerable
      extend Forwardable
      delegate [:each, :[]] => :exchanges
    end
  end
end

require 'hobby/test/report/exchange'
