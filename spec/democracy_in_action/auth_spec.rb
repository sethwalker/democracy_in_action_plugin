require File.dirname(__FILE__) + '/../spec_helper'

describe DemocracyInAction::Mirroring do
  before do
    User = mock('user_class')
  end
  def act!
    DemocracyInAction.configure do |c|
      c.auth.username = 'user'
      c.auth.password = 'password'
      c.auth.org_key  = '1234'
    end
  end
  it "should set the username" do
    act!
  end
end
