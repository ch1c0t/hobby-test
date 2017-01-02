require 'to_proc/all'
require 'include_constants'
require 'excon'

require 'yaml'
require 'json'
require 'forwardable'
require 'ostruct'

module Hobby
  class Test
    def self.from_file string
      new YAML.load_file string
    end

    def self.from_string string
      new YAML.load string
    end

    def initialize array_of_hashes
      @exchanges = array_of_hashes.map &Exchange
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

    include_constants from: ToProc
  end
end

require 'hobby/test/exchange'
require 'hobby/test/report'
require 'hobby/test/env'
