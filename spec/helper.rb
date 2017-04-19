require_relative 'setup/power_assert'
require_relative 'setup/mutant'
require_relative 'apps/main'

require 'hobby/test'
require 'puma'

RSpec.configure do |config|
  config.expect_with :rspec, :minitest

  config.after :suite do
    `rm *.socket` unless Dir['*.socket'].empty?
  end
end
