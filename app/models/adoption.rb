class Adoption
  include Mongoid::Document

  field :raffle_number
  field :fee, :type => Integer

  referenced_in :user
  references_many :ducks

  before_create :save_ducks

  # Helper method to generate number of ducks when user enters count on first page
  def duck_count= count
    return if persisted?

    self.ducks = (1..count.to_i).to_a.collect{Duck.new}
  end
  def duck_count
    self.ducks.count
  end
  private
  def save_ducks
    self.ducks.each{|d| d.save}
  end
end