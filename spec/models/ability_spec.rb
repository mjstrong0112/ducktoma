require 'spec_helper'
require "cancan/matchers"
describe Ability do
  context "as a normal user" do
    before(:each) do
      @user = Fabricate.build(:user)
      @ability = Ability.new(@user)
    end
    it "lets user read adoptions" do
      @ability.should be_able_to :read, Adoption
    end
    it "lets user create an adoption" do
      @ability.should be_able_to :create, Adoption
    end
    it "doesn't allow user to update or destroy adoptions" do
      @ability.should_not be_able_to :update, Adoption
      @ability.should_not be_able_to :destroy, Adoption
    end
  end
  context "as a guest" do
    before(:each) do
      @ability = Ability.new(nil)
    end
    it "lets guest create an adoption" do
      @ability.should be_able_to :create, Adoption
    end
    it "doesn't allow guest to read, update, or destroy adoptions" do
      @ability.should_not be_able_to :read, Adoption
      @ability.should_not be_able_to :update, Adoption
      @ability.should_not be_able_to :destroy, Adoption
    end
  end
  context "as an admin" do
    before(:each) do
    @admin = Fabricate.build(:admin)
      @ability = Ability.new(@admin)
    end
    it "gives total access" do
      @ability.should be_able_to :manage, :all
    end
  end
end