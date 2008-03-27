require File.dirname(__FILE__) + '/../spec_helper'

describe DemocracyInAction::Config do
  it "should respond to instance" do
    DemocracyInAction::Config.should respond_to(:instance)
  end
  describe ", an instance" do
    before do
      @c = DemocracyInAction::Config.instance
    end
    describe ", the auth method" do
      it "returns an object" do
        @c.auth.should be_a_kind_of(DemocracyInAction::Config::Node)
      end
    end
  end
  describe DemocracyInAction::Config::Node do
    before do
      @node = DemocracyInAction::Config::Node.new :auth
    end
    it "should know it's name" do
      @node.node_name.should == :auth
    end
    describe "attributes" do
      it "should be nil when first accessed" do
        @node.username.should be_nil
      end
      it "should be settable" do
        @node.username= 'user'
        @node.username.should == 'user'
      end
    end
    it "should nest arbitrarily deeply" do
      pending "should it?" do
        lambda { @node.username.first.next.last }.should_not raise_error
      end
    end
  end
end
