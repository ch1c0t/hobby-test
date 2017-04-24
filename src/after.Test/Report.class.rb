def initialize exchange_reports
  @exchange_reports = exchange_reports
end

def ok?
  @exchange_reports.all? &:ok?
end

def to_s
  @exchange_reports.join "\n\n"
end

include Enumerable
extend Forwardable
delegate [:each, :[], :size] => :@exchange_reports
