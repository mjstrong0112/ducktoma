require 'spec_helper'

describe Admin::AdoptionsController do

  context "as an admin" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
    end

    it "loads valid adoptions with pagination on GET 'index'" do
      all_adoptions = (1..30).to_a.collect{Fabricate(:adoption)}
      get :index
      response.should be_success
      assigns(:adoptions).to_a.should_not == all_adoptions
      assigns(:adoptions).to_a.count.should == Adoption.valid.paginate(:page => 1).to_a.count
    end

  end

  context "as a non-admin" do

    before(:each) do
      @user = Fabricate(:user)
      sign_in @user
    end

    it "redirects to root on GET user adoptions 'index'" do
      get :index
      response.should_not be_success
      response.should redirect_to root_path
    end

  end

  context "as a guest" do
    it "redirects to login on GET user adoptions 'index'" do
      get :index
      response.should_not be_success
      response.should redirect_to(new_user_session_path)
    end
  end

end