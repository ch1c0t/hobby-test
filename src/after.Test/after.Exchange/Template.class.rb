def initialize string
  @string = string
end

def [] env
  env.instance_eval @string
end
