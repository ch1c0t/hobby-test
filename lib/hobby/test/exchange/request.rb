class Hobby::Test::Exchange
  class Request < OpenStruct
    VERBS = %w[delete get head options patch post put]
    def initialize array
      @verb = array[0]
      super array[1]
    end
    attr_reader :verb

    def to_hash
      hash = to_h
      hash[:body] = hash[:body].to_json
      hash
    end
  end
end
