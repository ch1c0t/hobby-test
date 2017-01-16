def initialize pair
  key, delimiter, chain = pair[0].partition /\.|\[/
  chain.prepend (delimiter == '[' ? 'self[' : 'self.') unless chain.empty?

  @key, @chain, @specified_value = key, chain, pair[1]
end
attr_reader :key, :chain, :specified_value, :actual_value

def ok?
  @ok
end

def [] response
  dup.assert response
end

protected
  def assert env
    @specified_value = fill_templates_with env
    @actual_value = env.last_response.public_send key
    compare
    self
  end

  def compare
    @ok = chain.empty? ? actual_value == specified_value : compare_chain
  end

  def compare_chain
    if chain.end_with? '>', '=', '<'
      actual_value.instance_eval "#{chain}(#{specified_value})"
    else
      (actual_value.instance_eval chain) == specified_value
    end
  end

  def fill_templates_with env
    case specified_value
    when Template
      specified_value[env]
    when Hash
      specified_value.rewrite do |node|
        value = node.value

        if value.is_a? Template
          node.with value: (value[env])
        else
          node
        end
      end
    else
      specified_value
    end
  end
