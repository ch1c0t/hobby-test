def initialize excon_response, format:
  @excon_response, @format = excon_response, format
end
attr_reader :format

def format= string
  case string
  when 'json' then JSON
  when 'text' then nil
  else
    raise "Wrong format #{string}."
  end
end

def body
  @body ||= if format
              format.load @excon_response.body
            else
              PlainBody.new @excon_response.body
            end
end

class PlainBody < String
  def == expected_response
    eql? expected_response.to_s
  end
end

extend Forwardable
delegate [:status, :headers] => :@excon_response

def to_yaml
 {
    status: status,
    headers: headers,
    body: body,
    format: format,
 }.to_yaml
end
