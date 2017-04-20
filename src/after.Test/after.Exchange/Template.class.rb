def initialize string
  @string = string[1..-2]
end

def [] env
  env.instance_eval @string
end

def to_s
  "(#{@string})"
end
