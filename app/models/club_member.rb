class ClubMember < ActiveRecord::Base
  
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :omniauthable
  
  attr_accessible :name,  :picture_url, :approved, :organization_id

  # There are two types of roles:
  #   Member:    Represents normal club member
  #   Organizer: Represents organization club leader. Can edit/create new club members.
  attr_accessible :role
  attr_accessible :email, :password, :password_confirmation, :remember_me # Devise Fields.  
  attr_accessible :provider, :uid, :oauth_token, :oauth_expires_at # Omniauth Fields.
  
  belongs_to :organization
  has_many :adoptions

  scope :leaders, where(:role => :leader)

  delegate :name, to: :organization, prefix: :organization

  validates_presence_of :name#, :email #, :organization



  def picture_url
    read_attribute(:picture_url) || 'default-avatar.png'
  end

  def total    
    dollar_fee adoptions.paid.sum(&:fee)
  end

  def donation_level
    org = organization.biggest_contributor
    return 0 if org == 0 
    (total / org * 100).to_i
  end

  # Gets relative donation level to total passed in
  def donation_level_for(passed_total)
    return 100 if passed_total == 0
    (self.total / passed_total * 100).to_i
  end

  def self.from_omniauth(auth)
    user = where(auth.slice(:provider, :uid))
    # If no omniauth record found, try to find existing user account.    
    user = where(email: auth[:info][:email]) if auth[:info][:email] && user.blank?
  
    user.first_or_create.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email if not auth.info.try(:email).try(:blank?)
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.cache_photo
      user.save!
      user
    end

  end

  def is_facebook?
    provider.to_s == "facebook"
  end


  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def fetch_picture type=:normal
    facebook.get_picture("me", :type => type)
  end

  def cache_photo
    self.picture_url = fetch_picture  
  end

  def creditable?
    role.to_s != "leader"
  end

  def is?(role)
    return true if role.to_s == "facebook"
    return true if self.role.to_s == role.to_s
    false
  end


  # Override devise pwd methods for omniauth integration.
  def email_required?
    false
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end