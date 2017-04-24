require 'yaml'
require 'json'
require 'forwardable'
require 'ostruct'

require 'to_proc/all'
require 'include_constants'
require 'excon'
require 'terminal-table'
require 'rainbow'

require 'hash/as/tree'
using Hash::As::Tree

include_constants from: ToProc

def self.from_file string, **defaults
  new (YAML.load_file string), defaults: defaults
end

def self.from_string string, **defaults
  new (YAML.load string), defaults: defaults
end

def initialize array_of_hashes, defaults: {}
  @exchanges = array_of_hashes
    .map(&[defaults, :merge])
    .map(&Exchange)
end

def [] address
  connection = if address.start_with? 'http'
                 Excon.new address
               else
                 Excon.new 'unix:///', socket: address
               end
  env = Env.new connection

  Report.new @exchanges.map &[env]
end
