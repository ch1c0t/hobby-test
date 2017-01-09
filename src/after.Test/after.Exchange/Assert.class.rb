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
  def assert response
    @actual_value = response.public_send key
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
