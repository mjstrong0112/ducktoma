class Pricing < ActiveRecord::Base
  attr_accessible :price, :quantity
  validates_presence_of :price, :quantity
end
