if defined? Mutant::CLI
  module Mutant
    class Selector::Expression
      def call _subject
        integration.all_tests
      end
    end

    require 'timeout'
    class Isolation::Fork
      def parent reader, writer, &block
        pid = process.fork do
          child reader, writer, &block
        end

        writer.close
        Timeout::timeout(3) { marshal.load reader }
      ensure
        process.kill :KILL, pid
        process.waitpid pid
      end
    end
  end
end
