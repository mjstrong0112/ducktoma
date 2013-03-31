require 'spec_helper'

describe Adoption do

  it "should save default fabricator adoptions" do
    adoptions = (1..20).collect{Fabricate.build(:adoption)}
    lambda{ adoptions.each{|a| a.save!} }.should_not raise_error
  end

  context "a new adoption" do
    before(:each) {
      @adoption = Fabricate(:adoption)
    }

    it "requires ducks to be valid" do
      adoption = Adoption.new
      adoption.should_not be_valid
    end

    it "generates ducks when duck_count is set" do      
      adoption = Adoption.new
      count = Forgery::Basic.number
      adoption.duck_count = count
      adoption.should have(count).ducks
      adoption.ducks.each do |duck|
        duck.should_not be_persisted
      end
    end

    it "generates a raffle number on create" do
      @adoption.save
      @adoption.adoption_number.should_not be_blank
    end

    it "generates correct duck_count based on pricing" do
      Pricing.delete_all
      pricing_rule_1 = Fabricate(:pricing, :quantity => 0, :price => 100)
      pricing_rule_2 = Fabricate(:pricing, :quantity => 10, :price => 95)
      pricing_rule_3 = Fabricate(:pricing, :quantity => 20, :price => 90)

      adoption_1 = Fabricate.build(:adoption, :fee => 900, :duck_count => 0)
      adoption_1.save
      adoption_1.duck_count.should == 9

      adoption_2 = Fabricate.build(:adoption, :fee => 1345, :duck_count => 0)
      adoption_2.save
      adoption_2.duck_count.should == 14

      adoption_3 = Fabricate.build(:adoption, :fee => 2300, :duck_count => 0)
      adoption_3.save
      adoption_3.duck_count.should == 25
    end

    it "generates fee on create" do
      @adoption.save
      @adoption.fee.should_not be_blank
    end

    it "generates fee with correct pricing system" do
      Pricing.delete_all
      pricing_rule_1 = Fabricate(:pricing, :quantity => 1, :price => 100)
      pricing_rule_2 = Fabricate(:pricing, :quantity => 5, :price => 80)
      pricing_rule_3 = Fabricate(:pricing, :quantity => 10, :price => 60)

      adoption_1 = Fabricate.build(:adoption, :duck_count => 3)
      adoption_1.save
      adoption_1.fee.should == pricing_rule_1.price * adoption_1.duck_count

      adoption_2 = Fabricate.build(:adoption, :duck_count => 9)
      adoption_2.save
      adoption_2.fee.should == pricing_rule_2.price * adoption_2.duck_count

      adoption_3 = Fabricate.build(:adoption, :duck_count => 12)
      adoption_3.save
      adoption_3.fee.should == pricing_rule_3.price * adoption_3.duck_count
    end    
  end

  it "doesn't allow string fees" do
    adoption = Fabricate.build(:adoption, :fee => 'shouldnotbevalid')
    adoption.should_not be_valid
  end

  it "destroys ducks when adoption is destroyed" do    
    adoption = Fabricate(:adoption, :duck_count => 1)
    duck_id = adoption.ducks.first.id
    adoption.destroy
    Duck.where(:id => duck_id).first.should be_nil
  end

  context "inventory exhausted" do

    before(:each) do
      Settings.instance.update_attributes({:duck_inventory => 10})
      Fabricate(:adoption, :duck_count => 10)      
    end

    it "should not allow adoption" do
      adoption = Fabricate.build(:adoption , :duck_count => 1)

      adoption.should_not be_valid(:create)
      adoption.errors[:duck_count].any?.should be_true

      Settings.instance.update_attributes({:duck_inventory => 11})
      adoption.should be_valid(:create)
    end
  end

end
