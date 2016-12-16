require 'helper'

describe :format do
  describe 'urlencoded by default' do
    it 'works' do
      report = yml 'passing.echo'
      assert { report.ok? }
    end
  end
end
