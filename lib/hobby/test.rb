require 'to_proc/all'
require 'excon'

require 'yaml'
require 'forwardable'
require 'ostruct'

require 'hobby/test/exchange'
require 'hobby/test/report'

module Hobby
  class Test
    def initialize file
      @exchanges = (YAML.load_file file).map &Exchange
    end

    def [] address
      connection = if address.start_with? 'http'
                     Excon.new address
                   else
                     Excon.new 'unix:///', socket: address
                   end

      responses = @exchanges.map(&:request).map do |request|
        connection.public_send request.verb, **request
      end

      Report.new @exchanges, responses
    end
  end
end
