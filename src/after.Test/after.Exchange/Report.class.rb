def initialize asserts:, request:, response:
  @asserts, @request, @response = asserts, request, response
end

def ok?
  @asserts.all? &:ok?
end

def to_s
  Terminal::Table.new do |t|
    status = ok? ? Rainbow('passed').green : Rainbow('failed').red
    t.add_row ['Status', status]

    t.add_row ['Request', @request.to_yaml]
    t.add_row ['Response', @response.to_yaml]
    
    unless ok?
      asserts = @asserts.map do |assert|
        string = assert.to_s
        assert.ok? ? Rainbow(string).green : Rainbow(string).red
      end
      t.add_row ['Failed', asserts.join("\n\n")]
    end

    t.style = { all_separators: true }
  end.to_s
end
