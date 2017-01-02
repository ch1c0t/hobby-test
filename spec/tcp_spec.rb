describe Hobby::Test do
  before do
    @tcp_pid = fork do
      server = Puma::Server.new MainApp.new
      server.add_tcp_listener 'localhost', 8080
      server.run
      sleep
    end

    begin
      Excon.get 'http://localhost:8080'
    rescue
      sleep 0.01
      retry
    end

  end

  after do
    `kill #{@tcp_pid}`
  end

  it 'in case of success' do
    test = described_class.from_file 'spec/yml/plain/basic.yml'
    report = test['http://localhost:8080']
    assert { report.ok? }
  end
end
