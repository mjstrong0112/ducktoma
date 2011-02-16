require 'spec_helper'

describe PaymentNotification do
  should_have_field :params, :type => Hash
  should_have_field :status
  should_have_field :transaction_id
  should_have_field :state, :type => String  
  
  should_embed_one :payer_info
  should_reference_one :adoption

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
