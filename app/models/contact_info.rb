class ContactInfo
  include Mongoid::Document

  field :full_name
  field :email
  field :phone

  field :address
  field :city
  field :state
  field :zip, :type => Integer

  embedded_in :contact_source, :inverse_of => :contact_info

  validates_presence_of :full_name, :phone, :address, :city, :state, :zip
  validates_numericality_of :zip, :only_integer => true, :greater_than_or_equal_to => 10000, :less_than_or_equal_to => 99999
  validates :email, :presence => true,
                    :format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    :uniqueness => { :case_sensitive => false }
  
  validates_length_of :phone, :minimum => 10, :maximum => 10
end
