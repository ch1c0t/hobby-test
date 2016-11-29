require 'helper'

describe Hobby::Test do
  before do
    @test = described_class.new 'spec/apps/Basic/0.yml'
    @socket = 'Basic.socket'

    @pid = fork do
      server = Puma::Server.new Basic.new
      server.add_unix_listener @socket
      server.add_tcp_listener 'localhost', 8080
      server.run
      sleep
    end

    begin
      fail unless File.exist? @socket
      Excon.get 'http://localhost:8080'
    rescue
      sleep 0.01
      retry
    end
  end

  after do
    `kill #{@pid}`
  end

  it 'works via tcp' do
    report = @test['http://localhost:8080']

    assert { report.ok? }
  end

  it 'works via unix socket' do
    report = @test[@socket]

    assert { report.ok? }
  end
end
