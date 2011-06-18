require 'spec_helper'

describe Admin::DucksController do

  describe "GET 'show'" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user

      @adoption = Fabricate(:adoption)
      @duck = Fabricate(:duck, :adoption_id => @adoption.id)      
    end

    it "is successful" do
      get :show, :number => @duck.number
      response.should be_success
    end

    it "shows an alert if number wasn't found" do
      get :show, :number => 'does-not-exist'
      response.should_not be_success
      flash[:alert] =~ /could not be found/
    end

    it "redirects to dashboard if number wasn't found" do
      get :show, :number => 'does-not-exist'
      response.should redirect_to admin_root_url      
    end

  end

end
