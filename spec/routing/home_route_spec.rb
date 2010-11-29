require 'spec_helper'

describe "routing to home" do
  it "routes / to adoptions#new" do
    { :get => "/" }.should route_to(
        :controller => "adoptions",
        :action => "new"
    )
  end
end