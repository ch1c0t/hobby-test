class Hobby::Test::Exchange
  class Request < OpenStruct
    def to_hash
      hash = to_h
      hash.delete :verb
      hash
    end
  end
end
