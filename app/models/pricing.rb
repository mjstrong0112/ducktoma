class Pricing
  include Mongoid::Document  
  field :price, :type => Integer
  field :quantity, :type => Integer

  validates_presence_of :price, :quantity
end
