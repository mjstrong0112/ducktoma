require 'whole_number_validator'
include ApplicationHelper
# ========
# Adoption
# ========
#
# = fields =
#   adoption_number:  Unique identifier for adoptions.
#
#   fee:              Amount paid for adoption.
#
#   type:             Adoption type. Can be "std" (PayPal) or "sales".
#
#   state:            Only used for PayPal adoptions, stores the stage
#                     in the paypal payment process this adoption is in.
class Adoption < ActiveRecord::Base

  # TODO: Switch out all "adoption_number" references to "number"
  # TODO: Switch out all "organization" references to "club"
  # TODO: Switch out all "type" with "sales_type" (polymorphism clash)
  attr_accessible :number, :fee, :dollar_fee, :sales_type, :duck_count, :adopter_info_attributes

  # TODO: Longterm un-white-list these to protect us from mass-assignment.
  attr_accessible :club_id, :sales_event_id, :user_id, :club_member_id

  # State of - PayPal - adoption.
  # Can be the following values:
  #   New:            User hasn't confirmed purchase or gone to PayPal website.
  #
  #   Pending:        User has confirmed purchase, but PayPal confirmation
  #                   IPN hasn't arrived.
  #
  #   Completed:      Payment completed, successful, IPN has arrived and
  #                   no problems encountered.
  #
  #   Invalid:        Cancelled adoption.
  attr_accessible :state


  # == associations ==
  has_many :ducks, :dependent => :destroy
  
  belongs_to :payment_notification
  belongs_to :sales_event
  belongs_to :club, :class_name => "Organization"
  belongs_to :club_member
  belongs_to :user
  
  has_one :adopter_info, :as => :contact, :class_name => "ContactInfo"

  # TODO: Implement nested attributes for contact info.
  accepts_nested_attributes_for :adopter_info

  # == validations ===
  validates_presence_of :ducks, :fee, :number
  #validates_numericality_of :fee, :only_integer => true
  validates_uniqueness_of :number
  validate :ducks_must_be_available, :on => :create

  # TODO: Reimplement this validation? Fee hack was removed.
  # -- validate :duck_count_must_correspond_to_fee, :on => :create

  # TODO: Figure out what to do with this?
  # Since this model is no longer embedded, it is no longer auto-created.
  # -- validates_associated :adopter_info

  # == scopes ==
  scope :valid,   where("state != 'invalid'")
  scope :invalid, where(:state => "invalid")
  scope :paid,    where("state != 'invalid' AND state != 'pending'")
  scope :sales,   where(:sales_type => "sales").order("number asc")

  # == hooks ==
  before_validation :save_duck_count, :save_fee, :create_adoption_number
  before_create :save_ducks


  # simple alias.
  def adoption_number; number; end
  def type; sales_type; end
  def type=(val); sales_type = val; end

  def full_name
    adopter_info.try(:full_name) || "None" 
  end

  def first_number
    self.ducks.first.number
  end

  def duck_count= count  
    return if persisted?
    self.ducks = (1..count.to_i).to_a.collect{Duck.new}
  end

  # Helper method to generate number of ducks when user enters count on first page.
  # Note: This performs a database query, so use with care as
  # it could potentially create N+1 queries if used recklessly.
  def duck_count
    self.ducks.size
  end

  # Returns cents-fee in dollars.
  def dollar_fee
    BigDecimal.new(fee.to_s)/100
  end

  # Converts dollars to cents.
  def dollar_fee= dollars
    n_dollars = BigDecimal.new(dollars)
    self.fee = (n_dollars*100).to_i
  end
  
  def calculate_fee  
    # Sort pricings from greatest to smallest
    pricings = Pricing.order("quantity desc").to_a
    
    # If no pricings exist, use default price of 50.
    return duck_count * 50 if pricings.count == 0

    # Grab right pricing from pricings-list
    # by its duck range.
    pricing = pricings.detect do |p|
     duck_count > p.quantity
    end

    # If no duck-range in a pricing corresponded
    # to our duck count, just use the last pricing.
    pricing ||= pricings.last

    # Alas, calculate the price.
    duck_count * pricing.price
  end
  
  def ducks_available?
    (duck_count + Duck.valid_count) <= Settings[:duck_inventory].to_i
  end

  # = Paypal encryption as defined by Ryan Bates from Railscasts.
  def paypal_encrypted(return_url, notify_url)
    values = {
      :business => PAYPAL['email'],
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => id,
      :cert_id => PAYPAL['cert_id'],
      :notify_url => notify_url
    }
    values.merge!({
      "amount_1" => dollar_fee,
      "item_name_1" => duck_count.to_s + ' ducks',
      "item_number_1" => id,
      "quantity_1" => 1
    })
    encrypt_for_paypal(values)
  end

  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/"+PAYPAL['cert_file'])
  APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
  APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end
  # = end paypal

  private
  # If the fee has been entered but the duck_count hasn't been generated,
  # presumably because javascript was turned off preventing the duck_count
  # from being sent in the post CREATE. Generate it here.
  def save_duck_count
    if (!fee.nil? && (duck_count.nil? || duck_count == 0))
      pricing = retrieve_pricing_scheme(fee)
      self.duck_count = fee/pricing.price
    end
  end

  def save_fee
    # Sales adoptions cannot auto-generate fee,
    # since sales fees are specified by the sale itself
    # and not by the ducktoma system.
    unless type == 'sales'
      self.fee ||= calculate_fee
    end
  end

  def create_adoption_number
    # Adoption numbers must be entered manually
    # for sales adoptions.
    return nil if type == 'sales'

    # Don't want to override a perfectly
    # good adoption_number if the number is already set.
    return nil if self.number.present?

    # Generate unique number.
    record = true
    while record
      random = "T#{Array.new(6){rand(6)}.join}"
      record = Adoption.where(:number => random).exists?
    end
    self.number = random
  end

  def save_ducks
    self.ducks.each{|d| d.save}
  end

  def duck_count_must_correspond_to_fee
    # Validation only apples when a duck_count exists.
    # If the duck_count is nil or 0, the ducks will be
    # generated on save_duck_count.
    return nil if duck_count == 0 || duck_count.nil?

    pricing = retrieve_pricing_scheme(fee)
    if(duck_count > fee/pricing.price)
      errors.add :duck_count, "does not correspond to amount donated."
    end

  end

  def ducks_must_be_available
    errors.add :duck_count, "is more than the available ducks" unless ducks_available?
  end
end