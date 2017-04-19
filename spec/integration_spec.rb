require 'helper'

describe 'passing and failing YAML specifications' do
  before :each do |example|
    @socket = "MainApp.for.#{example}.socket"
    @pid = fork do
      server = Puma::Server.new MainApp.new
      server.add_unix_listener @socket
      server.run
      sleep
    end

    sleep 0.01 until File.exist? @socket
  end

  after :each do 
    `kill #{@pid}`
  end

  Dir["spec/yml/passed/json/*.yml"].each do |path|
    name = path.split('/').last
    test = Hobby::Test.from_file path, format: JSON

    it "passing #{name}" do
      report = test[@socket]
      assert { report.ok? }
    end
  end

  Dir["spec/yml/passed/plain/*.yml"].each do |path|
    name = path.split('/').last
    test = Hobby::Test.from_file path

    it "passing #{name} plain text" do
      report = test[@socket]
      assert { report.ok? }
    end
  end
end
