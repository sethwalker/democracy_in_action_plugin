require File.dirname(__FILE__) + '/../spec_helper'

describe DemocracyInAction::Mirroring do
  before do
    User = mock('user_class')
  end
  def act!
    DemocracyInAction.configure do |c|
      c.mirroring.supporter = User
    end
  end
  it "should set up observers" do
    DemocracyInAction::Mirroring.should_receive(:mirror).with('supporter', User)
    act!
  end
end
