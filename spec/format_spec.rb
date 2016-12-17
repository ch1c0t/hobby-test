require 'helper'

describe :format do
  it 'urlencoded by default' do
    report = yml 'passing.echo'
    assert { report.ok? }
  end

  it "compares with #to_json when specified" do
    report = yml 'passing.echojson'
    assert { report.ok? }
  end
end
