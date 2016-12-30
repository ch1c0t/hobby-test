class Hobby::Test::Exchange
  class Request < OpenStruct
    VERBS = %w[delete get head options patch post put]
    def initialize pair
      @verb, hash = pair

      template_fields, regular_fields = hash.partition do |key, _|
        key.start_with? 'template.'
      end
      @templates = template_fields.map &Hobby::Test::Template

      super regular_fields.to_h
    end
    attr_reader :verb

    def to_hash
      hash = to_h
      hash[:body] = hash[:body].to_json if hash[:body]
      hash
    end

    def perform_in env
      params = to_hash.merge @templates.map(&[env]).to_h
      env.responses << (env.connection.public_send verb, **params)
    end
  end
end
