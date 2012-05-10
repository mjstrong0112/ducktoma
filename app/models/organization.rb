class Organization
  include Mongoid::Document

  field :name
  references_many :adoptions

  validates :name, :presence => true

  def self.to_collection
    Organization.all(:sort => :name).map(&:name)
  end
  
end
