require 'puma'
require_relative 'spec/apps/main'

server = Puma::Server.new MainApp.new
server.add_unix_listener 'debug.socket'
server.run
sleep
