class SalesEvent < ActiveRecord::Base

  rails_admin do
    #object_label_method 
    #  name
    #end
  end

  attr_accessible :date 
  # TODO: Long term remove this to prevent mass-assignment vulnerability.
  attr_accessible :location_id, :organization_id

  has_many :adoptions
  has_many :creators, through: :adoptions, source: :user

  belongs_to :location
  belongs_to :organization

  def name
    [organization.try(:name), location.try(:name), date].compact.join(", ")
  end

end
