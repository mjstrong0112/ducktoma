require 'spec_helper'

describe Adoption do

  should_have_field :raffle_number
  should_have_field :fee, :type => Integer

  should_be_referenced_in :user

  it "should save default fabricator users" do
    adoptions = (1..20).collect{Fabricate.build(:adoption)}
    lambda{ adoptions.each{|a| a.save!} }.should_not raise_error
  end
end