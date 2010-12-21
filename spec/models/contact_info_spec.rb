require 'spec_helper'

describe ContactInfo do
  should_have_field :full_name, :type => String
  should_have_field :phone, :type => String
  should_have_field :email, :type => String

  should_have_field :address, :type => String
  should_have_field :city, :type => String
  should_have_field :state, :type => String
  should_have_field :zip, :type => Integer

  should_validate_presence_of :full_name, :phone, :email, :address, :city, :state, :zip
  should_validate_numericality_of :zip, :greater_than_or_equal_to => 10000, :less_than_or_equal_to => 99999

  should_be_embedded_in :contact_source

end
