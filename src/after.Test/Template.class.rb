def initialize pair
  @key = pair.first.partition('.').last.to_sym
  @string = pair.last
end

def [] env
  value = env.instance_eval @string
  [@key, value]
end
