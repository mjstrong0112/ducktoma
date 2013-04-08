class OmniauthUser < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :name, :oauth_expires_at, :oauth_token, :picture_url, :provider, :uid

  def self.from_omniauth(auth)
    user = where(auth.slice(:provider, :uid)).first || OmniauthUser.new(auth.slice(:provider, :uid))
    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.cache_photo
    user.save!
    user
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

  def admin?
    false
  end

end
