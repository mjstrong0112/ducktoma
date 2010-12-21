class Adoption
  include Mongoid::Document

  field :raffle_number
  field :fee, :type => Integer

  referenced_in :user
  references_many :ducks

  embeds_one :adopter_info, :class_name => "ContactInfo"

  accepts_nested_attributes_for :adopter_info

  validates_presence_of :ducks
  validates_associated :adopter_info
  before_create :save_fee, :create_raffle_number, :save_ducks

  # Helper method to generate number of ducks when user enters count on first page
  def duck_count= count    
    return if persisted?
    self.ducks = (1..count.to_i).to_a.collect{Duck.new}
  end
  def duck_count
    self.ducks.count    
  end
  private
  def save_fee
    self.fee = generate_fee(self.ducks)
  end
  def generate_fee(ducks)
    pricings = Pricing.desc(:quantity).to_a
    if pricings.count > 0
      pricing = pricings.detect do |p|
       duck_count > p.quantity
      end
      pricing ||= pricings.last

      duck_count * pricing.price
    else
      duck_count * 50;
    end
  end
  def create_raffle_number
    if self.raffle_number.blank?
      record=true
      while record
        random = "R#{Array.new(9){rand(9)}.join}"
        record = Adoption.where(:raffle_number => random).exists?
      end
      self.raffle_number = random
    end
  end
  def save_ducks
    self.ducks.each{|d| d.save}
  end
end