module ClubMembersHelper

  def user_type_icon user
    if user.provider == "facebook"
      image_tag "fb-account-type.png"
    else
      image_tag "email-account-type.png"
    end
  end

  def provider_text user
    user.provider ? 'facebook' : 'email'
  end
  
end
