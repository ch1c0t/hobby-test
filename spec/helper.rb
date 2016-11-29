require_relative 'setup/power_assert'
require_relative 'setup/mutant'
require_relative 'setup/apps'

require 'hobby/test'

RSpec.configure do |config|
  config.expect_with :rspec, :minitest
  config.around :each do |example|
    Timeout.timeout 5, &example
  end
end
