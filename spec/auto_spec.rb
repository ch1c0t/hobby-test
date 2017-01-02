require 'helper'

describe 'passing and failing YAML specifications' do
  Dir["spec/yml/json/*.yml"].each do |path|
    name = path.split('/').last
    test = Hobby::Test.from_file path, format: JSON

    it "passing #{name}" do
      report = test[@socket]
      assert { report.ok? }
    end
  end

  Dir["spec/yml/plain/*.yml"].each do |path|
    name = path.split('/').last
    test = Hobby::Test.from_file path

    it "passing #{name} plain text" do
      report = test[@socket]
      assert { report.ok? }
    end
  end
end
