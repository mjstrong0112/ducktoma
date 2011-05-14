class SalesEvent
  include Mongoid::Document

  references_many :adoptions, :dependent => :destroy

  field :location
  field :organization
  field :date, :type => String

  def creators
    ids = adoptions.map{|a| a.user_id}.compact
    unless ids.blank?
      User.find(ids)
    else
      {}
    end
  end
end
