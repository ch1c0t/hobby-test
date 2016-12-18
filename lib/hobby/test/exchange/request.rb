class Hobby::Test::Exchange
  class Request < OpenStruct
    def to_hash
      hash = to_h
      hash.delete :verb
      hash[:body] = hash[:body].to_json
      hash
    end
  end
end
