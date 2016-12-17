require_relative 'setup/power_assert'
require_relative 'setup/mutant'
require_relative 'apps/main'

require 'hobby/test'
require 'puma'

RSpec.configure do |config|
  config.expect_with :rspec, :minitest

  config.before :each do |example|
    @socket = "MainApp.for.#{example}.socket"
    @pid = fork do
      server = Puma::Server.new MainApp.new
      server.add_unix_listener @socket
      server.run
      sleep
    end

    sleep 0.01 until File.exist? @socket
  end

  config.after :each do 
    `kill #{@pid}`
  end

  config.after :suite do
    `rm *.socket`
  end
end
