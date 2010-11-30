require 'spec_helper'

describe AdoptionsController do
  context "as a valid user" do
    before(:each) do
      @user = Fabricate(:user)
      sign_in @user
    end
    it "loads all adoptions on GET 'index'" do
      Adoption.delete_all
      all_adoptions = (1..5).to_a.collect{Fabricate(:adoption)}
      get :index
      response.should be_success
      assigns(:adoptions).to_a.should == all_adoptions
    end
    it "belongs to user" do
      get :index, :user => @user
      response.should be_success
      assigns(:adoptions).to_a.should == @user.adoptions
    end
  end
  context "as a guest" do
    it "redirects to login on GET user adoptions 'index'" do
      get :index, :user => Fabricate.build(:user)
      response.should_not be_success
      response.should redirect_to(new_user_session_path)
    end
  end

  context "POST 'create'" do
    context "success" do
      before(:each) do
        @attr = { :duck_count => 5 }
      end
      it "creates an adoption" do
        lambda do
          post :create, :adoption => @attr
        end.should change(Adoption, :count).by(1)
      end
      it "redirects to the adoption show page" do
        post :create, :adoption => @attr
        response.should redirect_to adoption_path(assigns(:adoption))
      end
      it "shows a success notice" do
        post :create, :adoption => @attr
        flash[:notice].should =~ /success/i
      end
    end
    context "failure" do
      before(:each) do
        @attr = { :duck_count => 0 }
      end
      it "doesn't create an adoption" do
        lambda do
          post :create, :adoption => @attr
        end.should_not change(Adoption, :count)
      end
      it "renders the 'new' page" do
        post :create, :adoption => @attr
        response.should render_template('new')
      end
    end
  end
end