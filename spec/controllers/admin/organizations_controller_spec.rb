require 'spec_helper'

describe Admin::OrganizationsController do

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

  context "PUT update" do
    before(:each) do
      @organization = Fabricate(:organization)
      @user = Fabricate(:admin)
      sign_in @user
    end

    describe "with valid information" do
      it "updates the organization's name" do
        put :update, :id => @organization.id, :organization => {:name => "Hello World"}
        @organization.reload
        @organization.name.should  == "Hello World"
      end
      it "should redirect to index" do
        put :update, :id => @organization.id, :organization => {:name => "Austin Best BBQ"}
        response.should redirect_to admin_organizations_url
      end
    end

    describe "with invalid information" do
      it "should render the edit page" do
        put :update, :id => @organization.id, :organization => {name: ""}
        response.should render_template('edit')
      end
    end
  end

  context "POST 'create'" do

    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
    end

    describe "with valid information" do
      before(:each) do
        @attr = { :name => "The Organization of Sertoma" }
      end
      it "creates a new organization" do
        lambda do
          post :create, :organization => @attr
        end.should change(Organization, :count).by(1)
      end
      it "redirects to index" do
        post :create, :organization => @attr
        response.should redirect_to admin_organizations_url
      end
    end

    describe "with invalid information" do
      before(:each) do
        @attr = {}
      end
      it "doesn't create a new organization" do
        lambda do
          post :create, :organization => @attr
        end.should_not change(Organization, :count)
      end
      it "renders the new page" do
        post :create, :organization => @attr
        response.should render_template('new')
      end
    end

  end

  context "DELETE 'destroy'" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
      @organization = Fabricate(:organization)
    end
    it "destroys the organization" do
      lambda do
        delete :destroy, :id => @organization.id
      end.should change(Organization, :count).by(-1)
    end
    it "redirects to index" do
      delete :destroy, :id => @organization.id
      response.should redirect_to admin_organizations_url
    end
  end

end