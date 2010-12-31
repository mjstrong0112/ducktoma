require 'spec_helper'

describe Admin::SettingsController do
  context "as an admin with settings" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
      Settings.write_attributes({:first_setting => "asetting"})
    end
    it "loads the app settings" do
      get :edit
      assigns(:settings).should == Settings.instance
    end
    it "updates the app settings" do
      put :update, :settings => {:first_setting => "updatedsetting", :new_setting => "testnew"}
      Settings[:first_setting].should == "updatedsetting"
      Settings[:new_setting].should == "testnew"
      # if it isn't changed then it was persisted properly
      Settings.instance.should_not be_changed
    end
  end
end