class Location
  include Mongoid::Document

  field :name
  
  validates :name, :presence => true

  def self.to_collection
    Location.all.map(&:name)
  end
  
end
