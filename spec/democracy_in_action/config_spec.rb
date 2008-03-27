require File.dirname(__FILE__) + '/../spec_helper'

describe DemocracyInAction::Config do
  it "should respond to instance" do
    DemocracyInAction::Config.should respond_to(:instance)
  end
end
