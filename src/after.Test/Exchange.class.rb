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

  response, global_format = hash.values_at :response, :format
  verb, params = hash.find &Key[Request::VERBS, :include?]

  @response_format = response&.delete :format

  @request = Request.new verb, params, global_format
  @asserts = (response&.map &Assert) || []
end

def [] env
  request_report = @request.perform_in env

  response = env.last_response
  response.format = @response_format if @response_format

  Report.new \
    request: request_report,
    response: response,
    asserts: @asserts.map(&[env])
end
