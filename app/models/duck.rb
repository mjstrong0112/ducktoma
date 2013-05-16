class Duck < ActiveRecord::Base

  attr_accessible :number, :adoption

  # == associations ==
  belongs_to :adoption

  # == validations ==
  validates_presence_of :number, :if => :persisted?

  # == hooks ==
  before_create :generate_number

  # == scopes ==
  def self.valid;   joins(:adoption).merge(Adoption.valid);   end
  def self.paid;    joins(:adoption).merge(Adoption.paid);    end
  def self.invalid; joins(:adoption).merge(Adoption.invalid); end
  def self.sales;   joins(:adoption).merge(Adoption.sales);   end


  def number= number
    write_attribute(:number, number)
  end

  def generate_number
    last_duck_number = Duck.maximum(:number)
    self.number = last_duck_number ? (last_duck_number + 1) : 1
  end

  def self.available?
    self.valid_count < Settings[:duck_inventory].to_i
  end

  # Returns number of ducks that correspond to valid adoptions.
  def self.valid_count
    Duck.joins(:adoption).where("adoptions.state != 'invalid'").count
  end
end