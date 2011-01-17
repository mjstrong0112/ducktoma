class Organization
  include Mongoid::Document

  field :name

  validates :name, :presence => true
end
