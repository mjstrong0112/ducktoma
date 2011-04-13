require 'spec_helper'

describe AdoptionsHelper do
  it "doesn't include pending adoptions in total fee count" do
    @adoption = Fabricate(:adoption, :fee => 5)
    @adoption_pending = Fabricate(:adoption, :fee => 5, :state => "pending")
    total_fee.should == 5
  end
  it "doesn't include pending adoptions in total duck count" do
    @adoption = Fabricate(:adoption, :duck_count => 5)
    @adoption_pending = Fabricate(:adoption, :duck_count => 3, :state => "pending")
    total_duck_count.should == 5
  end
end
