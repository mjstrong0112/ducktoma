class FacebookUser
  include Mongoid::Document
  field :provider, :type => String
  field :uid, :type => String
  field :name, :type => String
  field :oauth_token, :type => String
  field :picture_url
  field :oauth_expires_at, :type => Time

  referenced_in :organization
  
  def self.from_omniauth(auth)
    user = where(auth.slice(:provider, :uid)).first || FacebookUser.new(auth.slice(:provider, :uid))
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

end
