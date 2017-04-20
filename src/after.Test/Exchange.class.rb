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

def [] env
  @request.perform_in env
  Report.new @asserts.map &[env]
end
