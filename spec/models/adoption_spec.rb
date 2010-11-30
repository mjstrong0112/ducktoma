require 'spec_helper'

describe Adoption do

  should_have_field :raffle_number
  should_have_field :fee, :type => Integer

  should_be_referenced_in :user
  should_reference_many :ducks  

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
  end
end