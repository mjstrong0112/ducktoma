class Organization < ActiveRecord::Base

  attr_accessible :name

  # == assocations ==
  has_many :adoptions
  has_many :sales_events
  
  validates_presence_of :name

  def self.to_collection
    Organization.order(:name).all.map { |o| [o.name, o.id] }
  end

end