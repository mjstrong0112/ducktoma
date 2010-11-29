class Duck
  include Mongoid::Document

  field :number, :type => Integer

  referenced_in :adoption

  validates_presence_of :number, :if => :persisted?
  validates_uniqueness_of :number

  before_create :generate_number

  #def number= count
  #  @number ||= count
  #end

  def generate_number
    last_duck_number = Duck.max(:number)
    self.number = last_duck_number ? (last_duck_number + 1) : 1
  end
end