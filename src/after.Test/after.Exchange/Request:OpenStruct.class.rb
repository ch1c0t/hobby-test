VERBS = %w[delete get head options patch post put]
def initialize triple
  @verb, hash, @format = triple

  template_fields, regular_fields = hash.partition &Key[:start_with?, 'template.']
  @templates = template_fields.map &Template

  super regular_fields.to_h
end
attr_reader :verb

def regular_fields
  hash = to_h

  if body && @format
    hash[:body] = @format.dump body
  end

  hash
end

def perform_in env
  params = regular_fields.merge @templates.map(&[env]).to_h
  
  excon_response = env.connection.public_send verb, **params
  response = Response.new excon_response, format: @format
  env.responses << response
end
