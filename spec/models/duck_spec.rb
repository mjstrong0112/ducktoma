require 'spec_helper'

describe Duck do

  context "when persisted" do
    # Force setting number to nil to test validate_presence_of
    subject { Duck.create.tap{|d| d.write_attribute(:number, nil)} }
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

  it "does not count invalid ducks for available?" do
    Settings.instance.update_attributes(:duck_inventory => 90)

    Fabricate(:adoption, :state => :invalid, :duck_count => 20)
    Fabricate(:adoption, :type => :std, :duck_count => 3)
    # Make sure ducks and adoptions were actually created.
    Duck.count.should == 23
    Adoption.count.should == 2

    Settings.instance.update_attributes(:duck_inventory => 5)
    
    # Even though there are 23 ducks in the database,
    # and only 5 in the inventory (after the inventory change),
    # the test should pass since 20 of the 23 ducks
    # are invalid ducks and do not count.
    Duck.should be_available
  end

  it "does count pending ducks for available?" do
    Settings.instance.update_attributes(:duck_inventory => 90)

    Fabricate(:adoption, :duck_count => 15, :state => "pending")
    Fabricate(:adoption, :duck_count => 3)

    # Make sure ducks and adoptions were actually created.
    Duck.count.should == 18
    Adoption.count.should == 2

    Settings.instance.update_attributes(:duck_inventory => 18)
    
    Duck.should_not be_available
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