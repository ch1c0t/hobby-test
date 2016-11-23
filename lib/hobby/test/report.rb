module Hobby
  class Test
    class Report
      def initialize exchanges
        @exchanges = exchanges
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
