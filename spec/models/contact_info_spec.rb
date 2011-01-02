require 'spec_helper'

describe ContactInfo do
  should_have_field :full_name, :type => String
  should_have_field :phone, :type => String
  should_have_field :email, :type => String

  should_have_field :address, :type => String
  should_have_field :city, :type => String
  should_have_field :state, :type => String
  should_have_field :zip, :type => Integer

  should_validate_presence_of :full_name
  should_validate_numericality_of :zip, :greater_than_or_equal_to => 10000, :less_than_or_equal_to => 99999

  should_be_embedded_in :contact_source

  it "requires either phone, email, or address" do
    #adoption = Fabricate.build(:adoption)
    #adoption.email = "lol@lol.com"
    #adoption.should be_valid
    contact_info = ContactInfo.new
    contact_info.full_name = "James Strong"
    contact_info.email = "lol@lol.com"
    contact_info.should be_valid

    contact_info = ContactInfo.new
    contact_info.full_name = "James Strong"
    contact_info.phone = "1234567890"
    contact_info.should be_valid

    contact_info = ContactInfo.new
    contact_info.full_name = "James Strong"
    contact_info.address = "my address"
    contact_info.should_not be_valid
    contact_info.city = "my city"
    contact_info.state = "TX"
    contact_info.zip = 94300
    contact_info.should be_valid
  end

end
