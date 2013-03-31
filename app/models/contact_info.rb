class ContactInfo < ActiveRecord::Base
  attr_accessible :address, :email, :full_name, :phone, :state, :city, :zip

  # TODO: Setup polymorphic relationship
  belongs_to :contact, polymorphic: true

  # = validations =
  validates_presence_of :full_name
  validates_numericality_of :zip, :only_integer => true, :greater_than_or_equal_to => 10000, :less_than_or_equal_to => 99999, :allow_blank => true
  validates :email, :format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    :uniqueness => { :case_sensitive => false }, :allow_blank => true

  validate :must_have_form_of_contact

  private
  # Either phone, email, or address, but not all are required.
  def must_have_form_of_contact
    if phone.blank? && email.blank? && (address.blank? || city.blank? || state.blank? || zip.blank?)      
      errors[:base] << "You must enter a phone, address, or email"
    end
  end

end
