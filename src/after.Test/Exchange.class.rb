using Module.new {
  refine Object do
    def template?
      is_a?(String) &&
        start_with?('(') &&
        end_with?(')')
    end
  end
}

def initialize hash
  hash = hash.rewrite do |node|
    value = node.value

    if value.template?
      node.with value: (Template.new value)
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
  Report.new \
    asserts: @asserts.map(&[env]),
    request: @request,
    response: env.last_response
end
