class Hobby::Test::Exchange
  class Assert
    def initialize pair
      @key, @expected_value = pair
    end

    def ok?
      @ok
    end
    
    def [] response
      dup.assert response
    end

    protected
      def assert response
        @actual_value = response.public_send @key
        @ok = @actual_value.to_s == @expected_value.to_s
        self
      end
  end
end
