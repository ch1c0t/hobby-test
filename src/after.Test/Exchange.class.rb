def initialize hash
  verb, params = hash.find &Key[Request::VERBS, :include?]
  @request = Request.new [verb, params, *hash[:format]]
  @asserts = (hash['response']&.map &Assert) || []
end
attr_reader :request, :asserts

def [] env
  dup.perform_in env
end

def ok?
  asserts.all? &:ok?
end

protected
  def perform_in env
    request.perform_in env
    @asserts = asserts.map &[env.last_response]
    self
  end
