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
        # I thought database cleaner cleared database before every test?
        # Apparently it's not working as intended.
        # So I clear the adoptions collection just in case before this test.
        Adoption.delete_all

        # Create sales adoptions and assign them to user
        (1..5).to_a.collect{Fabricate(:sales_adoption, :user_id => @user.id)}

        # Create non sales adoptions assigned to user
        # to make sure that the controller only pulls
        # adoptions with state new.
        5.times{Fabricate(:adoption, :state => "pending", :user_id => @user.id)}

        # Create some sales adoptions that are not assigned to
        # the user as well, just for good measure.
        5.times{Fabricate(:adoption, :state => "new")}


        sales_adoptions = Adoption.where(:state => "new", :user_id => @user.id)
                          .order_by([:adoption_number, :asc])
        
        get :index
        assigns(:adoptions).to_a.should == sales_adoptions
        assigns(:adoptions).to_a.should_not == @user.adoptions
        assigns(:adoptions).to_a.should_not == Adoption.all
      end

      it "doesn't show non-sales adoptions" do
        user_adoptions = (1..5).to_a.collect{Fabricate(:adoption, :user_id => @user.id, :type => :std)}
        get :index
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
    it "redirects to login on GET user adoptions 'index'" do
      get :index
      response.should_not be_success
      response.should redirect_to(new_user_session_path)
    end
  end
end