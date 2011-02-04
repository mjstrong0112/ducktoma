class SalesEvent
  include Mongoid::Document

  references_many :adoptions, :dependent => :destroy

  field :location
  field :organization
  field :date, :type => String

  def creators
    User.find(adoptions.map{|a| a.user_id})
  end
end
