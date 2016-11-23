require 'helper'

describe Hobby::Test do
  before do
    @test = described_class.new 'spec/apps/Basic/0.yml'
  end

  it 'works via tcp' do
    report = @test['http://localhost:8080']

    assert { report.ok? }
  end

  it 'works via unix socket' do
    report = @test[APPS[Basic]]

    assert { report.ok? }
  end
end
