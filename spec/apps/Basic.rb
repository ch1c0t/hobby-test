require 'hobby'

class Basic
  include Hobby::App
  get { 'root-only app' }
end
