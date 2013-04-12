class ClubMember < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  
  attr_accessible :name,  :picture_url # Custom fields.
  attr_accessible :email, :password, :password_confirmation, :remember_me # Devise Fields.  
  attr_accessible :provider, :uid, :oauth_token, :oauth_expires_at # Omniauth Fields.
  
  belongs_to :organization
  has_many :adoptions



  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.cache_photo
      user.save!
      user
    end
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

  # TODO: Implement.
  def is?(role)
    return true if role.to_s == "facebook"
    false
  end

  # Override devise pwd methods for omniauth integration.
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