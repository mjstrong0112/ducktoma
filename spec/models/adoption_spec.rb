require 'spec_helper'

describe Adoption do

  should_have_field :raffle_number
  should_have_field :fee, :type => Integer
  should_have_field :state, :type => String

  should_be_referenced_in :user  
  should_reference_many :ducks  

  should_embed_one :adopter_info
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
      @adoption.raffle_number.should_not be_blank
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
      Fabricate(:adoption, :duck_count => 10)
      Settings.update_attributes({:duck_inventory => 10})
    end
    it "should not allow adoption" do
      adoption = Fabricate.build(:adoption , :duck_count => 1)
      mock.proxy(adoption).ducks_available? {|result| result.should be false; result}
      adoption.should_not be_valid(:create)
      adoption.errors[:duck_count].any?.should be true
      Settings[:duck_inventory] = 11
      mock.proxy(adoption).ducks_available? {|result| result.should be true; result}
      adoption.should be_valid(:create)
    end
  end
  describe "it's state" do
    it "is new by default" do
      subject.should be_new
    end
    it "can be confirmed or canceled when new" do
      [:confirm, :cancel].each {|s| subject.send(:"can_#{s}?").should be true }
      #subject.confirm.should == true
      #subject.cancel.should == true
    end
    context "when completed" do
      before(:all) { subject.state = :completed }
      it "can be canceled" do
        subject.can_cancel?.should be true
      end
    end
    context "when canceled" do
      before(:all) { subject.state = :canceled }
      it "is permanentely canceled" do
        subject.should have(0).state_events
      end
    end
  end
end
