require 'spec_helper'

describe PaymentNotificationsController do
  it "renders nothing on create" do
    adoption = Fabricate(:adoption)
    post :create, :secret => PAYPAL['secret']
    response.body.should be_blank
  end
  it "creates a orphaned payment notification when sent invalid invoice id" do
    orphans_count = PaymentNotification.orphans.count
    post :create, :secret => PAYPAL['secret']
    PaymentNotification.orphans.count.should  == orphans_count+1
  end

  it "creates an unauthorized payment notification when invalid secret is sent in" do
    unauthorized_count = PaymentNotification.unauthorized.count
    adoption = Fabricate(:adoption)
    post :create, :invoice => adoption.id
    PaymentNotification.unauthorized.count.should == unauthorized_count+1
  end
end