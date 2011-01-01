class Duck
  include Mongoid::Document

  field :number, :type => Integer

  referenced_in :adoption

  validates_presence_of :number, :if => :persisted?

  before_create :generate_number

  def number= number
    read_attribute(:number) || write_attribute(:number, number)
  end

  def generate_number
    last_duck_number = Duck.max(:number)
    self.number = last_duck_number ? (last_duck_number + 1) : 1
  end

  def self.available?
    Duck.count < Settings[:duck_inventory]
  end
end
