class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = ClubMember.from_omniauth request.env["omniauth.auth"]
    if user.persisted? 
      flash.notice = "Signed in successfully!"
      sign_in user    
      redirect_to club_member_path(user)
    else 
      flash.alert = "There was a problem. Please try again."
      redirect_to root_url
    end
  end
  alias_method :facebook, :all

end
