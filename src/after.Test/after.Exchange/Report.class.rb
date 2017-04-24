def initialize asserts:, request:, response:
  @asserts, @request, @response = asserts, request, response
end

def ok?
  @asserts.all? &:ok?
end

def to_s
  Terminal::Table.new do |t|
    status = exchange_report.ok? ? Rainbow('passed').green : Rainbow('failed').red
    t.add_row ['Status', status]

    t.add_row ['Request', @request.to_yaml]
    t.add_row ['Response', @response.to_yaml]

    t.style = { all_separators: true }
  end.to_s
end
