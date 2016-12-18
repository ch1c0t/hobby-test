require 'hobby'
require 'hobby/json'

class MainApp
  include Hobby::App
  get { 'root-only app' }

  class Counter
    include Hobby::App
    @@counter = 0
    get { @@counter }
    post { @@counter += 1 }
  end
  map('/counter') { run Counter.new }

  class Echo
    include Hobby::App
    include Hobby::JSON

    get { json }
  end
  map('/echo') { run Echo.new }
  get('/echo-with-query') { request.params.to_json }

  class Query
    include Hobby::App
    get { request.params['array'].class }
  end
  map('/query') { run Query.new }
end
