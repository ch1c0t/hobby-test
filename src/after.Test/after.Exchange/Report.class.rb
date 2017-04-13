def initialize asserts
  @asserts = asserts
end

def ok?
  @asserts.all? &:ok?
end

include Enumerable
extend Forwardable
delegate [:each, :[], :size] => :@asserts
