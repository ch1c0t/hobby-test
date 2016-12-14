require 'mutant'

Runner = Mutant::Runner
Bootstrap = Mutant::Env::Bootstrap
Integration = Mutant::Integration

require 'tra/run'
module MyIsolation
  def self.call &block
    pid = fork do
      Process.setproctitle Process.pid.to_s
      Process.ppid.put block.call
    end
    Timeout.timeout(3) { Tra.next }
  rescue
    Process.kill :KILL, pid
    fail Mutant::Isolation::Error
  ensure
    Process.waitpid pid
  end
end

class MyIntegration
  def initialize _config
  end
  
  def setup
    self
  end
end

DEFAULT = Mutant::Config::DEFAULT
config = DEFAULT.with \
  matcher: DEFAULT.matcher.add(:match_expressions, DEFAULT.expression_parser.(ARGV[0])),
  integration: Integration.setup(Kernel, 'rspec'),
  isolation: MyIsolation

#Runner.call Bootstrap.call config

env = Bootstrap.call config
puts "#{env.mutations.size} mutations are to be checked."
result_mutations = env.mutations.map.with_index 1 do |mutation, index|
  puts index
  env.kill mutation
end

failed_mutations = result_mutations.reject &:success?
if failed_mutations.empty?
  puts 'Covered.'
else
  require 'pry'
  failed_mutations.__binding__.pry
end
