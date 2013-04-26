class Organization < ActiveRecord::Base

  default_scope order('name')


  attr_accessible :name, :description, :avatar, :avatar_cache

  # == assocations ==
  has_many :adoptions, foreign_key: "club_id"
  has_many :sales_events
  has_many :club_members

  has_many :member_adoptions, through: :club_members, source: :adoptions
  
  validates_presence_of :name

  mount_uploader :avatar, AvatarUploader

  def biggest_contribution
    dollar_fee Adoption.paid.joins(:club_member => :organization).where("organizations.id = ?", id)
                .select("SUM(adoptions.fee) as total_fee")
                .group("club_member_id")
                .order('total_fee desc')
                .limit(1)
                .first.try(:total_fee)
  end


  def total_paid
    dollar_fee adoptions.paid.sum(&:fee) + member_adoptions.paid.sum(&:fee) 
  end

  def self.to_collection
    Organization.order(:name).all.map { |o| [o.name, o.id] }
  end

end