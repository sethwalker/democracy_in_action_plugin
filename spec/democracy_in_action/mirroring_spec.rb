require File.dirname(__FILE__) + '/../spec_helper'

DemocracyInAction::API::DIA_ENABLED = false

describe DemocracyInAction::Mirroring do

  before do
    auth_config = File.dirname(__FILE__) + '/../auth.yml'
    @auth = YAML::load(IO.read(auth_config)) if File.exist?(auth_config)
    Object.remove_class User if Object.const_defined?(:User)
    class User < ActiveRecord::Base; end
  end

  it "should be available thru mirror in configure" do
    DemocracyInAction::Mirroring.should_receive(:mirror).with(:supporter, User)
    DemocracyInAction.configure { mirror(:supporter, User) }
  end

  describe "mirror method" do
    it "should accept a block" do
      lambda { DemocracyInAction::Mirroring.mirror(:supporter, User) { 'code' } }.should_not raise_error
    end
    it "should make map available inside the block" do
      lambda { DemocracyInAction::Mirroring.mirror(:supporter, User) {
        map('First_Name') {|user| user.name }
      } }.should_not raise_error
    end
  end

  describe "a mirrored class" do
    before do
      DemocracyInAction::Mirroring.mirror(:supporter, User)
    end

    it "should include DemocracyInAction::Mirroring::ActiveRecord" do
      User.included_modules.should include(DemocracyInAction::Mirroring::ActiveRecord)
    end

    it "should receive the after save call" do
      DemocracyInAction::Mirroring.mirror(:supporter, User)
      user = User.new
      DemocracyInAction::Mirroring::ActiveRecord.should_receive(:after_save).with(user)
      user.save
    end

    it "should remember the map" do
      User.democracy_in_action = nil if User.respond_to?(:democracy_in_action)
      DemocracyInAction::Mirroring.mirror(:supporter, User) do
        map('First_Name') {|user| user.name }
      end
      u = User.new :name => 'dweezil'
      User.democracy_in_action.mappings(u)['First_Name'].should == 'dweezil'
    end

    it "should also be able to set static values" do
      User.democracy_in_action = nil if User.respond_to?(:democracy_in_action)
      DemocracyInAction::Mirroring.mirror(:supporter, User) do
        map('First_Name', 'moon unit')
      end
      u = User.new :name => 'dweezil'
      User.democracy_in_action.mappings(u)['First_Name'].should == 'moon unit'
    end
  end

  describe "defaults" do
    before do
      @mirror = DemocracyInAction::Mirroring::Mirror.new('supporter', User)
    end
    before do
      @defaults = @mirror.defaults({:first_name => 'firstly', :last_name => 'lastly', :organization => 'organizationally'})
    end
    it "should generate a hash with DemocracyInAction field names for keys" do
      @defaults['First_Name'].should == 'firstly'
    end
    it "should not allow illegal columns" do
      @defaults.keys.should_not include('Password')
    end
  end
end
