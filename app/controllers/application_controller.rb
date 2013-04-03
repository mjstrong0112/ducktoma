class ApplicationController < ActionController::Base
  protect_from_forgery

  alias_method :current_devise_user, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "rake #{task} #{args.join(' ')} &"
  end

  def current_user
    if session[:omniauth_user_id]
      @omniauth_user ||= OmniauthUser.find session[:omniauth_user_id]      
    else
      current_devise_user
    end
  end

end
