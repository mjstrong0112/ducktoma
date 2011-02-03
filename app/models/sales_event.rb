class SalesEvent
  include Mongoid::Document

  references_many :adoptions

  field :location
  field :organization
  field :date, :type => Date
end
