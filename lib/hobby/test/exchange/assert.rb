class Hobby::Test::Exchange
  module Assert
    def self.[] pair
      const_get(pair[0].capitalize).new pair[1]
    end

    def initialize value
      @expected_value = format value
    end

    def format value
      value
    end

    def ok?
      @ok
    end
    
    def [] response
      dup.assert response
    end

    attr_reader :actual_value, :expected_value
    protected
      def assert response
        @actual_value = response.public_send self.class.key
        @ok = actual_value == expected_value
        self
      end

    def self.included assert
      assert.extend Singleton
    end

    module Singleton
      def key
        to_s.split('::').last.downcase
      end
    end

    class Status
      include Assert
    end

    class Body
      include Assert

      def format value
        value.is_a?(Hash) ? value.to_json : value.to_s
      end
    end
  end
end
