require 'spec_helper'

describe Admin::PricingsController do
  context "GET 'index'" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
    end
    it "loads all pricing rules by descending quantity order" do
      Pricing.delete_all
      (1..30).to_a.collect{Fabricate(:pricing)}
      get :index
      response.should be_success
      assigns(:pricings).to_a.should == Pricing.order('quantity DESC')
    end

  end
  context "POST 'create'" do
    before(:each) do
      @user = Fabricate(:admin)
      sign_in @user
    end
    describe "with valid information" do
      before(:each) do
        @attr = {:quantity => 3, :price => 48}
      end
      it "creates a pricing rule" do
        lambda do
          post :create, :pricing => @attr
        end.should change(Pricing, :count).by(1)
      end
      it "redirects to index" do
        post :create, :pricing => @attr
        response.should redirect_to admin_pricings_path
      end
    end
    describe "with invalid information" do
      before(:each) do
        @attr = { }
      end
      it "does not create a pricing rule" do
        lambda do
          post :create, :pricing => @attr
        end.should_not change(Pricing, :count)
      end
    end
  end
end