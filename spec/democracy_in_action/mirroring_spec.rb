require File.dirname(__FILE__) + '/../spec_helper'

describe DemocracyInAction::Mirroring do
  before do
    Object.remove_class User if Object.const_defined?(:User)
    ::User = Class.new(ActiveRecord::Base)
    auth_config = File.dirname(__FILE__) + '/../auth.yml'
    @auth = YAML::load(IO.read(auth_config)) if File.exist?(auth_config)
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
  describe "mirror method" do
    it "should set up after_save on the model" do
      User.should_receive(:after_save).with(DemocracyInAction::Mirroring::ActiveRecord)
      DemocracyInAction::Mirroring.mirror('supporter', User)
    end
    it "should receive the after save call" do
      act!
      user = User.new
      DemocracyInAction::Mirroring::ActiveRecord.should_receive(:after_save).with(user)
      user.save
    end
    it "should not die" do
      act!
      user = User.new
      user.save
    end
  end
end
