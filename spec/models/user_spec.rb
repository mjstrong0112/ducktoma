require 'spec_helper'

describe User do

  before(:all) do
    @basic_user = User.new
  end

  it "should save successfully with password" do
    user = User.new(:email => "test@test.com", :password => "testing123")
    lambda{user.save!}.should_not raise_error
    User.count.should == 1
    first = User.first
    first.id.should == user.id
    first.should_not be_a_valid_password("notright")
    first.should be_a_valid_password("testing123")
  end

  it "should save default fabricator user" do
    user = Fabricate.build(:user)
    lambda{ user.save! }.should_not raise_error
    user.adoptions.should_not be_blank
  end

  it "can be an admin" do
    @basic_user.role = :admin
    @basic_user.is?(:admin).should be_true
    @basic_user.is?(:sales).should be_true
  end

  it "can be a sales associate" do
    @basic_user.role = :sales
    @basic_user.is?(:admin).should_not be_true
    @basic_user.is?(:sales).should be_true
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
  context "an admin user" do
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
  end
end
