class SessionsController < ApplicationController
  def create
    user = OmniauthUser.from_omniauth(env["omniauth.auth"])
    session[:omniauth_user_id] = user.id
    redirect_to omniauth_user_path(user)
  end

  def destroy
    session[:omniauth_user_id] = nil
    redirect_to root_url
  end
end