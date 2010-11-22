require 'spec_helper'

describe User do
  should_validate_presence_of :email
  should_validate_uniqueness_of :email
  should_validate_confirmation_of :password
  before(:all) do
    @basic_user = User.new
  end
  it "should save successfully with password" do
    user = User.new(:email => "test@test.com", :password => "testing")
    lambda{user.save!}.should_not raise_error
    User.count.should == 1
    first = User.first
    first.id.should == user.id
    first.valid_password?("notright").should be false
    first.valid_password?("testing").should be true
  end
  it "should save default fabricator user" do
    user = Fabricate.build(:user)
    lambda{ user.save! }.should_not raise_error
  end
#  it "could be an admin user" do
#    @basic_user.respond_to?(:admin?).should be true
#  end

  context "a standard boring user" do
    before(:each) do
      @user = Fabricate(:user)
    end
#    it "will not be an admin" do
#      @user.admin?.should be false
#    end
#    it "can update itself" do
#      Ability.new(@user).should be_able_to(:update, @user)
#    end
#    it "cannot update an unrelated user" do
#      @other_user = Fabricate(:user)
#      Ability.new(@user).should_not be_able_to(:update, @other_user)
#    end
  end
#  context "an admin user" do
#    before(:each) do
#      @user = Fabricate(:admin)
#    end
#    it "will say its an admin" do
#      @user.admin?.should be true
#    end
#    it "can update an unrelated user" do
#      @other_user = Fabricate(:user)
#      Ability.new(@user).should be_able_to(:update, @other_user)
#    end
#  end
end
