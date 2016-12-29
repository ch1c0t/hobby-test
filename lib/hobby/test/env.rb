module Hobby
  class Test
    class Env < OpenStruct
      def initialize connection
        super connection: connection
      end
    end
  end
end
