require 'hobby'
require 'hobby/json'

class MainApp
  include Hobby::App
  get { 'root' }

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

  class HashApp
    include Hobby::App
    include Hobby::JSON
    get do
      {
        'a' => 1,
        'b' => 2,
        'c' => 3
      }
    end
  end
  map('/hash') { run HashApp.new }

  class ArrayApp
    include Hobby::App
    include Hobby::JSON
    get do
      [
        {
          'first' => {
            'a' => 0, 'b' => 1
          },
          'second' => {
            'c' => 2, 'd' => 3
          }
        },
        {
          'first' => {
            'a' => 5, 'b' => 6
          },
          'second' => {
            'c' => 2, 'd' => 3
          }
        }
      ]
    end
  end
  map('/array') { run ArrayApp.new }
end
