require 'spec_helper'

describe Sales::AdoptionsController do
  context "as a sales user" do
    before(:each) do
      @user = Fabricate(:sales_user)
      sign_in @user
    end
    it "GET 'new' is successful" do
      get :new
      response.should be_success
    end
  end
  context "as an admin" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
    end
    it "GET 'new' is successful" do
      get :new
      response.should be_success
    end
  end
  context "as a standard user" do
    before(:each) do
      @user = Fabricate(:user)
      sign_in @user
    end
    it "redirects to root on GET user adoptions 'new'" do
      get :new
      response.should_not be_success
      response.should redirect_to root_path
    end
  end
  context "as a guest" do
    it "redirects to login on GET user adoptions 'new'" do
      get :index
      response.should_not be_success
      response.should redirect_to(new_user_session_path)
    end
  end
end