def initialize connection
  super connection: connection, responses: []
end

def last_response
  responses.last
end

def uri *all
  "/#{all.join '/'}"
end
