require 'spec_helper'

describe Dauphin::Runtime do
  before :each do
    Dauphin::Runtime.any_instance.stub(:check_for_binary).and_return(true)
  end

  it 'returns the correct default path on windows' do
    Dauphin::Platform.stub(windows?: true)
    Dauphin::Platform.stub(linux?: false)
    runtime = Dauphin::Runtime.new
    runtime.default_executable_path.should == 'C:/Program Files/Prince/Engine/bin/prince'
  end

  it 'returns the correct default path on linux' do
    Dauphin::Platform.stub(linux?: true)
    Dauphin::Platform.stub(windows?: false)

    runtime = Dauphin::Runtime.new
    runtime.default_executable_path.should == `which prince`
  end
end