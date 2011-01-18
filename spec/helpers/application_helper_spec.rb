require 'spec_helper'

describe ApplicationHelper do
  describe "retrieve_pricing_scheme" do    
    it "should retrieve the right pricings" do
      Pricing.delete_all
      pricing_rule_1 = Fabricate(:pricing, :quantity => 0, :price => 100)
      pricing_rule_2 = Fabricate(:pricing, :quantity => 10, :price => 95)
      pricing_rule_3 = Fabricate(:pricing, :quantity => 20, :price => 90)

      retrieve_pricing_scheme(900).should == pricing_rule_1
      retrieve_pricing_scheme(1340).should == pricing_rule_2
      retrieve_pricing_scheme(4567).should == pricing_rule_3
    end
  end
end
