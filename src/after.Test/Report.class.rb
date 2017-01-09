def initialize exchanges
  @exchanges = exchanges
end

def ok?
  @exchanges.all? &:ok?
end

include Enumerable
extend Forwardable
delegate [:each, :[], :size] => :@exchanges
