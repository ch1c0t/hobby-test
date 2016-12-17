require 'hobby'

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

  get('/echo') { request.params }
  require 'json'
  get('/echo.json') { request.params.to_json }
end
