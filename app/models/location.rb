class Location < ActiveRecord::Base
  
  attr_accessible :name
  validates_presence_of :name
  has_many :sales_events


  def self.to_collection
    Location.order(:name).all.map { |l| [l.name, l.id] }
  end

end
