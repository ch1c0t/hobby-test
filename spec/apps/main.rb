require 'hobby'

class MainApp
  include Hobby::App
  get { 'root-only app' }
end
