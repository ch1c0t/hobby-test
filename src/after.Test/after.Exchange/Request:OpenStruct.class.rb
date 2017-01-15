VERBS = %w[delete get head options patch post put]
def initialize triple
  @verb, hash, @format = triple
  super hash
end
attr_reader :verb

def perform_in env
  excon_response = env.connection.public_send verb, **(create_params env)
  response = Response.new excon_response, format: @format
  env.responses << response
end

private
  def create_params env
    serialize to_h.rewrite { |node|
      next node unless node.value.is_a? String
      string = node.value

      if string.start_with?('(') && string.end_with?(')')
        node.with value: (env.instance_eval string[1..-2])
      else
        node
      end
    }
  end

  def serialize hash
    if body && @format
      hash[:body] = @format.dump body
    end

    hash
  end
