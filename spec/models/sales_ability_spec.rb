require 'spec_helper'
require "cancan/matchers"
describe SalesAbility do
  context "as sales user" do
    before(:each) do
      @user = Fabricate.build(:sales_user)      
      @ability = SalesAbility.new(@user)
    end
    it "gives complete access" do
      @ability.should be_able_to :manage, :all      
    end
  end
  context "as admin user" do
    before(:each) do
      @user = Fabricate.build(:admin)
      @ability = SalesAbility.new(@user)
    end
    it "gives complete access" do
      @ability.should be_able_to :manage, :all
    end
  end
  context "as standard user" do
    before(:each) do
      @user = Fabricate.build(:user)
      @ability = SalesAbility.new(@user)
    end
    it "should not give user any access" do
      @ability.should_not be_able_to :create, Adoption
      @ability.should_not be_able_to :read, Adoption
      @ability.should_not be_able_to :update, Adoption
      @ability.should_not be_able_to :destroy, Adoption
    end
  end
end