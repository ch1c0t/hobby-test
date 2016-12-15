class Hobby::Test::Exchange
  class Assert
    def initialize pair
      @key, @value = pair
    end

    def ok?
      @ok
    end
    
    def [] response
      dup.assert response
    end

    protected
      def assert response
        @ok = true if @value == (response.public_send @key)
        self
      end
  end
end
