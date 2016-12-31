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

    def regular_fields body_serializer:
      hash = to_h

      if body && body_serializer
        hash[:body] = body_serializer.dump body
      end

      hash
    end

    def perform_in env
      body_serializer = JSON if body.is_a? Hash
      params = regular_fields(body_serializer: body_serializer)
        .merge @templates.map(&[env]).to_h
      
      excon_response = env.connection.public_send verb, **params
      response = Response.new excon_response, body_serializer: body_serializer
      env.responses << response
    end
  end
end
