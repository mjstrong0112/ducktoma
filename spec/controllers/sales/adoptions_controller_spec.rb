require 'spec_helper'

describe Sales::AdoptionsController do
  context "as a sales user" do
    before(:each) do
      @user = Fabricate(:sales_user)
      sign_in @user
    end
    context "GET 'index'" do
      it "is successful" do
        get :index
        response.should be_success
      end
      it "shows users sales adoptions" do
        sales_adoptions = (1..5).to_a.collect{Fabricate(:sales_adoption, :user_id => @user.id)}
        5.times{Fabricate(:adoption)}
        get :index
        response.should be_success
        assigns(:adoptions).to_a.should == sales_adoptions
        assigns(:adoptions).to_a.should_not == Adoption.all
      end
      it "doesn't show non-sales adoptions" do
        user_adoptions = (1..5).to_a.collect{Fabricate(:adoption, :user_id => @user.id, :type => :std)}
        get :index
        response.should be_success
        assigns(:adoptions).to_a.should_not == user_adoptions
      end
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