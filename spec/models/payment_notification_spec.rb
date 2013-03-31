require 'spec_helper'

describe PaymentNotification do

  it "new payment notifications have a valid state" do
    pn = PaymentNotification.new
    pn.valid_state?.should == true
  end

  it "has a valid state for new and completed" do
    pn = PaymentNotification.new
    pn.state = 'new'
    pn.valid_state?.should == true
    pn.state = 'completed'
    pn.valid_state?.should == true
  end

  it "has an invalid state for unauthorized failed and orphan" do
    pn = PaymentNotification.new
    pn.state = 'unauthorized'
    pn.valid_state?.should == false
    pn.state = 'failed'
    pn.valid_state?.should == false
    pn.state = 'orphan'
    pn.valid_state?.should == false
  end
end
