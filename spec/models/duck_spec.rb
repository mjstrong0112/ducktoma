require 'spec_helper'

describe Duck do
  should_have_field :number, :type => Integer
  should_be_referenced_in :adoption

  should_validate_presence_of :number

  it "can save default fabricator ducks" do
    ducks = (1..20).collect{Fabricate.build(:duck)}
    lambda{ ducks.each{|a| a.save!} }.should_not raise_error
  end

  it "has an immutable number field" do
    duck = Fabricate.build(:duck)
    number = duck.number
    duck.number = number+1
    duck.number.should == number
  end
end