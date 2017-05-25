VERBS = %i[delete get head options patch post put]
def initialize verb, params, format
  @verb = verb

  if local_format = params.delete('format')
    @format = case local_format
              when 'json' then JSON
              when 'text' then nil
              else
                raise "Wrong format #{local_format}."
              end
  else
    @format = format
  end

  super params
end
attr_reader :verb

def perform_in env
  params = create_params env
  report = Report.new params, @format

  excon_response = env.connection.public_send verb, **(serialize params)

  response = Response.new excon_response, format: @format
  env.responses << response

  report
end

private
  def create_params env
    to_h.rewrite { |node|
      next node unless node.value.is_a? Template
      node.with value: node.value[env]
    }
  end

  def serialize hash
    hash = hash.dup

    if body && @format
      hash[:body] = @format.dump body
    end

    hash
  end

class Report
  def initialize params, format
    @params = params.dup

    if format
      @params[:format] = format
    end
  end

  def to_yaml
    @params.to_yaml
  end
end
