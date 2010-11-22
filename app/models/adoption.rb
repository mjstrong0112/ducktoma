class Adoption
  include Mongoid::Document

  field :raffle_number
  field :fee, :type => Integer

  referenced_in :user
end