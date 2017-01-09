Gem::Specification.new do |g|
  g.name    = 'hobby-test'
  g.files   = ['lib/hobby/test.rb']
  g.version = '0.0.5'
  g.summary = 'A way to test HTTP exchanges via YAML specifications'
  g.authors = ['Anatoly Chernow']

  g.add_dependency 'excon'
  g.add_dependency 'to_proc', '>= 0.0.7'
  g.add_dependency 'include_constants'
end
