require 'devtools/spec_helper'

require 'minitest'
require 'minitest-power_assert'

assert = if ENV['PRY']
  require 'pry'
  require 'awesome_print'

  Module.new do
    def assert &block
      PowerAssert.start Proc.new, assertion_method: __method__ do |pa|
        block.binding.pry unless pa.yield
      end
    end
  end
else
  Minitest::PowerAssert::Assertions
end

Minitest::Assertions.prepend assert


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
