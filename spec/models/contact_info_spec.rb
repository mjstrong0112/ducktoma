require 'spec_helper'

describe ContactInfo do

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
