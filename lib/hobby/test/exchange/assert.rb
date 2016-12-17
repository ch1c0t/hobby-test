class Hobby::Test::Exchange
  class Assert
    def initialize key, value, format = :to_s
      @key, @expected_value, @format = key, value, format
      @format = "to_#{format}" unless format == :to_s
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
        @ok = @actual_value.to_s == (@expected_value.public_send @format)
        self
      end
  end
end
