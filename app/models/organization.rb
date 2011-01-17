class Organization
  include Mongoid::Document

  field :name

  validates :name, :presence => true

  def self.to_collection
    Organization.all.map(&:name)
  end
  
end
