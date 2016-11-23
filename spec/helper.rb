require 'devtools/spec_helper'

require_relative 'setup_power_assert'
require_relative 'setup_mutant'


require_relative 'apps/Basic'
require 'puma'
require 'hobby/test'
require 'securerandom'

RSpec.configure do |config|
  config.expect_with :rspec, :minitest

  config.before :suite do
    server = Puma::Server.new Basic.new
    random = SecureRandom.hex 16

    server.add_unix_listener "Basic.#{random}.socket"
    
    begin
      Excon.get 'http://localhost:8080'
    rescue Excon::Error::Socket
      server.add_tcp_listener 'localhost', 8080
    end

    server.run
  end
end
