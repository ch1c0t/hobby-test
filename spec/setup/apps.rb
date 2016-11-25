require 'puma'
require_relative '../apps/Basic'

APPS = {}

server = Puma::Server.new Basic.new
socket = 'Basic.socket'

APPS[Basic] = socket
server.add_unix_listener socket
server.add_tcp_listener 'localhost', 8080

server.run
