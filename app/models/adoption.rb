class Adoption
  include Mongoid::Document

  field :raffle_number
  field :fee, :type => Integer
  field :type

  referenced_in :user
  references_many :ducks

  embeds_one :adopter_info, :class_name => "ContactInfo"

  accepts_nested_attributes_for :adopter_info

  before_validation :save_fee, :create_raffle_number
  validates_presence_of :ducks, :fee, :raffle_number
  validates_associated :adopter_info
  validate :ducks_must_be_available, :on => :create

  before_create :save_ducks

  # Helper method to generate number of ducks when user enters count on first page
  def duck_count= count    
    return if persisted?
    self.ducks = (1..count.to_i).to_a.collect{Duck.new}
  end
  def duck_count
    self.ducks.count    
  end
  def dollar_fee
    BigDecimal.new(fee.to_s)/100
  end
  def calculate_fee
    pricings = Pricing.desc(:quantity).to_a
    if pricings.count > 0
      pricing = pricings.detect do |p|
       duck_count >= p.quantity
      end
      pricing ||= pricings.last

      duck_count * pricing.price
    else
      duck_count * 50;
    end
  end
  def ducks_available?
    (duck_count + Duck.count) <= Settings[:duck_inventory]
  end

  private

  def save_fee
    unless type == 'sales'
      self.fee ||= calculate_fee
    end
  end
  def create_raffle_number
    unless type == 'sales'
      if self.raffle_number.blank?
        record=true
        while record
          random = "R#{Array.new(9){rand(9)}.join}"
          record = Adoption.where(:raffle_number => random).exists?
        end
        self.raffle_number = random
      end
    end
  end
  def save_ducks
    self.ducks.each{|d| d.save}
  end
  def ducks_must_be_available
    errors.add :duck_count, "is more than the available ducks" unless ducks_available?
  end
end
