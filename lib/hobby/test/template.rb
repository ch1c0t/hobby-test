module Hobby
  class Test
    class Template
      def initialize pair
        @key = pair.first.partition('.').last.to_sym
        @string = pair.last
      end

      def [] env
        value = env.instance_eval @string
        [@key, value]
      end
    end
  end
end
