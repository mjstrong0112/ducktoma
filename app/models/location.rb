class Location
  include Mongoid::Document

  field :name
  
  validates_presence_of :name

  def self.to_collection
    Location.all(:sort => :name).map(&:name)
  end
  
end
