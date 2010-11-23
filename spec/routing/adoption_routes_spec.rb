require 'spec_helper'

describe "routing to adoptions" do
  it "routes user adoptions to adoptions" do
    @user = Fabricate(:user)
    { :get => user_adoptions_path(@user) }.should route_to(
        :controller => "adoptions",
        :action => "index",
        :user_id => @user.id.to_s
    )
  end
  it "routes adoptions to adoptions" do
    { :get => adoptions_path }.should route_to(
        :controller => "adoptions",
        :action => "index"
    )
  end
end