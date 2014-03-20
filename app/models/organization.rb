class Organization < ActiveRecord::Base

  default_scope order('name')
  scope :members_permitted, where(permit_members: true)


  attr_accessible :name, :description, :avatar, :avatar_cache, :permit_members

  # == assocations ==
  has_many :adoptions, foreign_key: "club_id"
  has_many :sales_events
  has_many :club_members

  has_many :member_adoptions, through: :club_members, source: :adoptions

  validates_presence_of :name
  validates_uniqueness_of :name

  mount_uploader :avatar, AvatarUploader


  def allow_members!
    update_attributes(permit_members: true)
  end

  def biggest_contributor
    dollar_fee Adoption.paid.joins(:club_member => :organization).where("organizations.id = ?", id)
                .select("SUM(adoptions.fee) as total_fee")
                .group("club_member_id")
                .order('total_fee desc')
                .limit(1)
                .first.try(:total_fee)
  end


  def total_paid

    ids = adoptions.paid.pluck('adoptions.id') +
          member_adoptions.paid.pluck('adoptions.id') +
          sales_events.map { |s| s.adoptions.pluck('adoptions.id') }
    ids = ids.flatten.uniq

    dollar_fee Adoption.where(id: ids).sum(&:fee)
  end

  def self.to_collection
    Organization.order(:name).all.map { |o| [o.name, o.id] }
  end

end