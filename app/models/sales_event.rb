class SalesEvent < ActiveRecord::Base

  attr_accessible :date 
  # TODO: Long term remove this to prevent mass-assignment vulnerability.
  attr_accessible :location_id, :organization_id

  has_many :adoptions
  has_many :creators, through: :adoptions, source: :user

  belongs_to :location
  belongs_to :organization

end
