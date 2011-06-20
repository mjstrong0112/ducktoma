require 'whole_number_validator'
include ApplicationHelper
class Adoption
  include Mongoid::Document
  include Mongoid::Timestamps

  field :adoption_number
  field :fee, :type => Integer
  index :fee
  field :type
  
  # State field for state machine. Default state MUST be specified.
  field :state, :type => String, :default => "new"
  index :state

  referenced_in :user
  referenced_in :payment_notification
  referenced_in :sales_event
  references_many :ducks, :dependent => :destroy
  embeds_one :adopter_info, :class_name => "ContactInfo"

  accepts_nested_attributes_for :adopter_info

  before_validation :save_duck_count, :save_fee, :create_adoption_number
  validates_presence_of :ducks, :fee, :adoption_number
   
  scope :valid, excludes(:state => "invalid")
  scope :invalid, where(:state => "invalid")
  scope :paid, not_in(:state => ["invalid", "pending"] )
  scope :sales, where(:type => "sales").order_by([:adoption_number, :asc])


  # State machine has been disabled due to
  # poor MongoDB support.
  
  # state_machine :initial => :new do
  #   event :confirm do
  #     transition :new => :pending
  #   end
  #   event :invalidate do
  #     transition :pending => :completed
  #   end
  #   event :complete do
  #     transition :pending => :completed
  #   end
  #   event :cancel do
  #     transition all - [:canceled] => :canceled
  #   end
  # end

  validates_associated :adopter_info
  validates_numericality_of :fee, :only_integer => true
  validates_uniqueness_of :adoption_number
  validate :ducks_must_be_available, :on => :create
  #validate :duck_count_must_correspond_to_fee, :on => :create

  before_create :save_ducks


  def duck_count= count    
    return if persisted?
    self.ducks = (1..count.to_i).to_a.collect{Duck.new}
  end

  # Helper method to generate number of ducks when user enters count on first page.
  # Note: This performs a database query, so use with care as
  # it could potentially create N+1 queries if used recklessly.
  def duck_count
    self.ducks.count
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
    # If no pricings exist, use default price of 50.
    pricings = Pricing.desc(:quantity).to_a
    if pricings.count > 0
      # Grab right pricing from pricings-list
      # by its duck range.
      pricing = pricings.detect do |p|
       duck_count > p.quantity
      end

      # If no duck-range in a pricing corresponded
      # to our duck count, just use the last pricing.
      pricing ||= pricings.last

      duck_count * pricing.price
    else
      duck_count * 50;
    end
  end

  def ducks_available?
    (duck_count + Duck.count) <= Settings[:duck_inventory]
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
    unless type == 'sales'
      if self.adoption_number.blank?
        record=true
        while record
          random = "R#{Array.new(9){rand(9)}.join}"
          record = Adoption.where(:adoption_number => random).exists?
        end
        self.adoption_number = random
      end
    end
  end

  def save_ducks
    self.ducks.each{|d| d.save}
  end

  def duck_count_must_correspond_to_fee
    # Only applies when a duck_count exists. If the duck_count is nil or 0,
    # it will be generated on save_duck_count.
    if(duck_count > 0)
      pricing = retrieve_pricing_scheme(fee)
      if(duck_count > fee/pricing.price)
        errors.add :duck_count, "does not correspond to amount donated."
      end
    end
  end

  def ducks_must_be_available
    errors.add :duck_count, "is more than the available ducks" unless ducks_available?
  end
end
