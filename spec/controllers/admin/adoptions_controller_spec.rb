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


    context "when exporting by club members" do

      before(:each) do
        @club_member = Fabricate(:club_member)
      end

      it "does not sum invalid adoptions" do
        Adoption.destroy_all

        Fabricate(:adoption, duck_count: 3, state: 'invalid', club_member: @club_member)
        Fabricate(:adoption, duck_count: 5, club_member: @club_member)
        get :export_by_club_member

        assigns(:club_members).first.tap do |club_member|
          club_member[:duck_count].should == 5
          club_member[:adoption_count].should == 1
        end
      end

      it "does not sum non-paid adoptions" do
        Adoption.destroy_all

        Fabricate(:adoption, duck_count: 10, state: 'pending', club_member: @club_member)
        Fabricate(:adoption, duck_count: 20, club_member: @club_member)
        Fabricate(:adoption, duck_count: 15, club_member: @club_member)
        get :export_by_club_member

        assigns(:club_members).first.tap do |club_member|
          club_member[:duck_count].should == 35
          club_member[:adoption_count].should == 2
        end
      end

      it "sums both sales and paypal adoptions" do
        Adoption.destroy_all

        Fabricate(:sales_adoption, fee: 50, duck_count: 1, sales_type: "sales", club_member: @club_member)
        Fabricate(:adoption, duck_count: 5, sales_type: "std", state: "completed", club_member: @club_member)
        get :export_by_club_member

        assigns(:club_members).first.tap do |club_member|
          club_member[:duck_count].should == 6
          club_member[:adoption_count].should == 2
        end
      end

      it "properly groups by club member" do
        Adoption.destroy_all

        @club_member_2 = Fabricate(:club_member)
        Fabricate(:adoption, duck_count: 10, club_member: @club_member)
        Fabricate(:adoption, duck_count: 5, club_member: @club_member_2)
        get :export_by_club_member

        assigns(:club_members).first[:duck_count].should == 10
        assigns(:club_members).last[:duck_count].should == 5
      end

      it "properly calculates fee by club member" do
        Adoption.destroy_all

        Fabricate(:adoption, duck_count: 10, club_member: @club_member)
        get :export_by_club_member

        assigns(:club_members).first[:fee].should == BigDecimal.new("5")
      end

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