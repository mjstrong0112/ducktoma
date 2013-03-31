class Organization
  include Mongoid::Document

  field :name
  references_many :adoptions
  references_many :facebook_users

  validates :name, :presence => true
  
  def self.to_collection
    Organization.all(:sort => :name).map(&:name)
  end
  
end
