require File.dirname(__FILE__) + '/../spec_helper'

DemocracyInAction::API::DIA_ENABLED = false

describe DemocracyInAction::Mirroring do

  before do
    Object.remove_class User if Object.const_defined?(:User)
    User = Class.new(ActiveRecord::Base)
    auth_config = File.dirname(__FILE__) + '/../auth.yml'
    @auth = YAML::load(IO.read(auth_config)) if File.exist?(auth_config)
  end

  it "should be available thru mirror in configure" do
    DemocracyInAction::Mirroring.should_receive(:mirror).with(:supporter, User)
    DemocracyInAction.configure { mirror(:supporter, User) }
  end

  describe "mirror method" do
    it "should set up after_save on the model" do
      User.stub!(:after_save)
      User.should_receive(:after_save).with(:update_democracy_in_action).once
      DemocracyInAction::Mirroring.mirror(:supporter, User)
    end
    it "should receive the after save call" do
      DemocracyInAction::Mirroring.mirror(:supporter, User)
      user = User.new
      user.should_receive(:update_democracy_in_action)
      user.save
    end
    it "should accept a block" do
      lambda { DemocracyInAction::Mirroring.mirror(:supporter, User) { 'code' } }.should_not raise_error
    end
    it "should make map available inside the block" do
      DemocracyInAction::Mirroring.mirror(:supporter, User) {
        map('Last_Name') {|user| user.family_name}
      }
    end
  end
  describe "map_defaults" do
    before do
      @defaults = DemocracyInAction::Mirroring::ActiveRecord.map_defaults({:first_name => 'firstly', :last_name => 'lastly', :organization => 'organizationally'})
    end
    it "should generate a hash with DemocracyInAction field names for keys" do
      @defaults['First_Name'].should == 'firstly'
    end
    it "should not allow illegal columns" do
      @defaults.keys.should_not include('Password')
    end
  end
end
