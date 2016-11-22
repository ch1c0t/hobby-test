require 'devtools/spec_helper'

require 'minitest'
require 'minitest-power_assert'
Minitest::Assertions.prepend Minitest::PowerAssert::Assertions

if defined? Mutant
  class Mutant::Selector::Expression
    def call _subject
      integration.all_tests
    end
  end
end

require_relative 'apps/Basic'
require 'puma'
require 'hobby/test'

RSpec.configure do |config|
  config.expect_with :rspec, :minitest
  config.before :suite do
    server = Puma::Server.new Basic.new
    server.add_unix_listener 'Basic.socket'
    server.add_tcp_listener 'localhost', 8080
    server.run
  end
end
