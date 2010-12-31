require 'spec_helper'

describe Admin::UsersController do
  before(:each) do
    @user= Fabricate(:admin)
    sign_in @user
  end
  it "loads users with pagination on GET 'index'" do
    all_users = (1..30).to_a.collect{Fabricate(:user)}
    get :index
    response.should be_success
    assigns(:users).to_a.should_not == all_users
    assigns(:users).to_a.should == User.paginate(:page => 1)
  end
  describe "PUT 'update'" do
    it "updates succesfully with blank passwords" do
      password = @user.password
      @attr = { :email => Forgery::Internet.email_address,
                :password => "", :password_confirmation => "" }
      put :update, :id => @user.id, :user => @attr
      @user.reload
      @user.email.should == @attr[:email]
      @user.password.should == password
      response.should redirect_to(admin_users_path)
    end
    context "with valid information" do
      before(:all) do
        @attr = {:email => Forgery::Internet.email_address,
                 :password => "updatedpass", :password_confirmation => "updatedpass"}
      end
      it "updates user information" do
        put :update, :id => @user.id, :user => @attr
        response.should redirect_to(admin_users_path)
        @user.reload
        @user.email.should == @attr[:email]
        @user.should be_a_valid_password @attr[:password]
      end
      it "updates roles" do
        @attr[:roles] = [:sales]
        @user.roles.should == [:admin]
        put :update, :id => @user.id, :user => @attr
        response.should redirect_to(admin_users_path)
        @user.reload
        @user.roles.should == @attr[:roles]
      end
    end
    context "with invalid information" do
      before(:all) do
        @attr = {:email => "invalidemail", :password => "abc", :password_confirmation => "xyz"}
      end
      it "does not update user information" do
        put :update, :id => @user.id, :user => @attr
        response.should render_template('edit')
        @user.reload
        @user.email.should_not == @attr[:email]
        @user.should_not be_a_valid_password @attr[:password]
      end
      it "doesn't update roles" do
        @attr[:roles] = [:sales]
        @user.roles.should == [:admin]
        put :update, :id => @user.id, :user => @attr
        response.should render_template('edit')
        @user.reload
        @user.roles.should_not == @attr[:roles]
      end
    end
  end
end