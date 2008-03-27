require File.dirname(__FILE__) + '/spec_helper'

describe DemocracyInAction do
  it "should respont do configure" do
    DemocracyInAction.should respond_to(:configure)
  end
  describe "configure" do
    it "should accept a block" do
      lambda { DemocracyInAction.configure { |c| }}.should_not raise_error
    end
    it "should not require a block" do
      lambda { DemocracyInAction.configure }.should_not raise_error
    end
    it "the block variable should respond to auth" do
      DemocracyInAction.configure do |c|
        lambda { c.auth}.should_not raise_error
      end
    end
    it "the block variable should respond to mirroring" do
      DemocracyInAction.configure do |c|
        lambda { c.mirroring }.should_not raise_error
      end
    end
  end
end
