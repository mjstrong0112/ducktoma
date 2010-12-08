require 'spec_helper'
require "cancan/matchers"
describe AdminAbility do
  context "as valid user" do
    before(:each) do
      @admin = Fabricate.build(:admin)
      #sign_in @admin
      @ability = AdminAbility.new(@admin)      
    end
    it "gives admin complete access" do
      @ability.should be_able_to :manage, :all      
    end
  end
  context "as invalid user" do
    before(:each) do
      @user = Fabricate.build(:user)
      @ability = AdminAbility.new(@user)
    end
    it "should not give user any access" do
      @ability.should_not be_able_to :create, Adoption
      @ability.should_not be_able_to :read, Adoption
      @ability.should_not be_able_to :update, Adoption
      @ability.should_not be_able_to :destroy, Adoption
    end
  end
end