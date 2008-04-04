require File.dirname(__FILE__) + '/../spec_helper'

describe DemocracyInAction::Proxy do
  before do
    Object.remove_class User if Object.const_defined?(:User)
    User = Class.new(ActiveRecord::Base)
  end
  it "can instantiate itself without throwing errors" do
    lambda { DemocracyInAction::Proxy.new }.should_not raise_error
  end
  it "belongs_to a model" do
    p = DemocracyInAction::Proxy.new
    p.local = User.create :name => 'test'
    p.local_type.should == 'User'
  end
end
