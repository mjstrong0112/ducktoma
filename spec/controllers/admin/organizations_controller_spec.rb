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

    context "Virtual Sales" do

      it "properly sums paid adoptions and ducks" do
        Adoption.destroy_all
        Fabricate(:adoption, duck_count: 3)
        Fabricate(:adoption, duck_count: 2)
        get :index

        assigns(:virtual_sales)[:total_ducks].should == 5
        assigns(:virtual_sales)[:total_donations].should == 250
      end

      it "doesn't sum non-paid adoptions and ducks" do
        Adoption.destroy_all
        5.times { Fabricate(:adoption, state: 'pending') }

        get :index
        assigns(:virtual_sales)[:total_ducks].should == 0
        assigns(:virtual_sales)[:total_donations].should == 0
      end
    end

    context "Organization Sales" do

      before(:each) do
        Adoption.destroy_all
        @org = Fabricate(:organization)
      end

      it "properly sums paid adoptions and ducks" do
        Fabricate(:adoption, duck_count: 3, club: @org)
        Fabricate(:adoption, duck_count: 2, club: @org)
        get :index

        values = assigns(:organization_values).first
        values[1][:total_ducks].should == 5
        values[1][:total_donations].should == 250
      end

      it "doesn't sum non-paid adoptions and ducks" do
        5.times { Fabricate(:adoption, club: @org, state: 'pending')}
        get :index

        values = assigns(:organization_values).first
        values[1][:total_ducks].should == 0
        values[1][:total_donations].should == 0
      end

      it "adds both direct-credit adoptions as well as sales-event-credit adoptions" do
      end

      it "does not double count adoptions assigned to both sales_event and direct organizations" do
        sales_event = Fabricate(:sales_event, organization: @org)
        Fabricate(:sales_adoption, duck_count: 3, club: @org, sales_event: sales_event)
        get :index

        values = assigns(:organization_values).first
        values[1][:total_ducks].should == 3
        values[1][:total_donations].should == 150
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