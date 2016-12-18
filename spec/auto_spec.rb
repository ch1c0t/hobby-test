require 'helper'

describe 'passing and failing YAML specifications' do
  Dir["spec/yml/**/*.yml"].each do |path|
    name = path.split('/').last
    test = Hobby::Test.new path

    if path.include? 'passing'
      it "passing #{name}" do
        report = test[@socket]
        assert { report.ok? }
      end
    else
      it "failing #{name}" do
        report = test[@socket]
        assert { not report.ok? }
      end
    end
  end
end
