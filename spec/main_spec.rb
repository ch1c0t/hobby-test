require 'helper'

describe Hobby::Test do
  it 'distinguishes between passing and failing tests' do
    passing_test = described_class.new 'spec/yml/passing.0.yml'
    failing_test = described_class.new 'spec/yml/failing.0.yml'

    assert { passing_test[@socket].ok? }
    assert { not failing_test[@socket].ok? }
  end

  it 'allows exchanges without assertions' do
    report = yml 'passing.counter'
    assert { report.ok? }
  end
end
