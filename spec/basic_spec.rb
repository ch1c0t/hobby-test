require 'helper'

describe Basic do
  it do
    test = Hobby::Test.new 'spec/apps/Basic/0.yml'
    report = test['http://localhost:8080']

    assert { report.ok? }
  end
end
