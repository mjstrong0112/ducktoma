class Duck
  include Mongoid::Document

  # == fields ==
  field :number, :type => Integer

  # == associations ==
  referenced_in :adoption

  # == validations ==
  validates_presence_of :number, :if => :persisted?

  # == hooks ==
  before_create :generate_number

  def number= number
    write_attribute(:number, number)
  end

  def generate_number
    last_duck_number = Duck.max(:number)
    self.number = last_duck_number ? (last_duck_number + 1) : 1
  end

  def self.available?
    Duck.count < Settings[:duck_inventory]
  end
end
