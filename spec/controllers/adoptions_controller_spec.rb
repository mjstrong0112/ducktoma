require 'spec_helper'

describe AdoptionsController do
  context "as a valid user" do
    before(:each) do
      @user = Fabricate(:user)
      sign_in @user
    end
    it "should load the users adoptions on GET 'index'" do
      get :index
      #current_user.adoptions = @user.adoptions
      response.should be_success
      #assigns(:adoptions).should == @user.adoptions
    end
  end
  context "as a guest" do
    it "should redirect to home on GET 'index'" do
      get :index
      response.should_not be_success
      #response.should be_redirect_to(home_path)
    end
  end
end