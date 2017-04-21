def initialize asserts:, request:, response:
  @asserts, @request, @response = asserts, request, response
end

def ok?
  @asserts.all? &:ok?
end
