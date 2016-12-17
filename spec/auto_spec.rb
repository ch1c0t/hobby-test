require 'helper'

describe 'passing and failing YAML specifications' do
  passing = %w[
    0
    counter
    echo
    echojson
  ]

  failing = %w[
    0
  ]

  passing.each do |name|
    path = "spec/yml/passing/#{name}.yml"
    it "passing #{name}" do
      test = Hobby::Test.new path
      report = test[@socket]
      assert { report.ok? }
    end
  end

  failing.each do |name|
    path = "spec/yml/failing/#{name}.yml"
    it "failing #{name}" do
      test = Hobby::Test.new path
      report = test[@socket]
      assert { not report.ok? }
    end
  end
end
