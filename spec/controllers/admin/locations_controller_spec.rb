require 'spec_helper'

describe Admin::LocationsController do
  context "GET 'index'" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
    end
    it "is successful" do
      get :index
      response.should be_success
    end
  end
  context "PUT update" do

    before(:each) do
      @location = Fabricate(:location)
      @user = Fabricate(:admin)
      sign_in @user
    end

    describe "with valid information" do
      it "updates the location's name" do
        put :update, :id => @location.id, :location => {:name => "Hello World"}
        @location.reload
        @location.name.should  == "Hello World"
      end
      it "should redirect to index" do
        put :update, :id => @location.id, :location => {:name => "Austin Best BBQ"}
        response.should redirect_to admin_locations_url
      end
    end

    describe "with invalid information" do
      it "should render the edit page" do
        put :update, :id => @location.id, :location => {:name => ""}
        response.should render_template('edit')
      end
    end

  end

  context "GET 'new'" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
    end
    it "is successful" do
      get :new
      response.should be_success
    end
  end

  context "POST 'create'" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
    end

    describe "with valid information" do
      before(:each) do
        @attr = {:name => "County of Rock and Roll - Austin Texas"}
      end
      it "creates a new location" do
        lambda do
          post :create, :location => @attr
        end.should change(Location, :count).by(1)
      end
      it "redirects to index" do
        post :create, :location => @attr
        response.should redirect_to admin_locations_url
      end
    end

    describe "with invalid information" do
      before(:each) do
        @attr = {}
      end
      it "doesn't create a new location" do
        lambda do
          post :create, :location => @attr
        end.should_not change(Location, :count)
      end
      it "renders the new page" do
        post :create, :location => @attr
        response.should render_template('new')
      end
    end

  end

  context "DELETE 'destroy'" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
      @location = Fabricate(:location)
    end
    it "destroys the location" do
      lambda do
        delete :destroy, :id => @location.id
      end.should change(Location, :count).by(-1)
    end
    it "redirects to index" do
      delete :destroy, :id => @location.id
      response.should redirect_to admin_locations_url
    end
  end

end