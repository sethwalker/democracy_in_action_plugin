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
    it "should yield a DemocracyInAction::Config instance" do
      DemocracyInAction.configure do |c|
        c.should be_a_kind_of(DemocracyInAction::Config)
      end
    end
  end
end
