# A workaround for
# https://github.com/mbj/mutant/#the-crash--stuck-problem-mri
#
# For Hobby::Test::Report
# https://gist.github.com/ch1c0t/c5e0a8de8de14d10bec49839fb6e2fee
# this mutation
# https://gist.github.com/ch1c0t/c1626fe232032489fad93dab8d3a10c0
# causes the infinite running.
#
# This workaround "solves" it by introducing a timeout enforced
# from the parent process.
#
# With this workaround, Mutant ends its run successfully, but lefts out
# a process which keeps running in the background. That process, apparently,
# is forked from the process with the offending mutation.
# TODO: find out why it happens; create a workaround for the workaround
# (because killing that process manually every time is too much hassle).
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
