module Hobby
  class Test
    class Report
      def initialize exchanges
        @exchanges = exchanges
      end

      def ok?
        @exchanges.all? &:passed?
      end

      include Enumerable
      extend Forwardable
      delegate [:each, :[], :size] => :@exchanges
    end
  end
end
