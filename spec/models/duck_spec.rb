require 'spec_helper'

describe Duck do
  should_have_field :number, :type => Integer
  should_be_referenced_in :adoption

  context "when persisted" do
    # Force setting number to nil to test validate_presence_of
    subject { Duck.create.tap{|d| d.write_attribute(:number, nil)} }
    it { should validate_presence_of :number }
  end
  it "can save default fabricator ducks" do
    ducks = (1..20).collect{Fabricate.build(:duck)}
    lambda{ ducks.each{|a| a.save!} }.should_not raise_error
  end
  it "generates a unique number" do
    ducks = (1..200).collect{Duck.create}
    ducks.map{|d| d.number}.uniq!.should be_nil
  end
  it "generates a number on create" do
    duck = Duck.new
    duck.save
    duck.number.should_not be_blank
  end
  
  # Duck numbers are no longer immutable
  # for the time being. Immutability was removed
  # in order to support the "generate duck numbers" function.

  #it "has an immutable number field" do
  #  duck = Fabricate.build(:duck)
  #  number = duck.number
  #  duck.number = number+1
  #  duck.number.should == number
  #end
end