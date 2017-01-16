def initialize hash
  hash = hash.rewrite do |node|
    value = node.value

    if value.is_a?(String) && value.start_with?('(') && value.end_with?(')')
      node.with value: (Template.new value[1..-2])
    else
      node
    end
  end

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
    @asserts = asserts.map &[env]
    self
  end
