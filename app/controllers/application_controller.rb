class ApplicationController < ActionController::Base
  helper :application
  protect_from_forgery

  alias_method :current_devise_user, :current_user


  def after_sign_in_path_for(resource)    
    if resource.class == ClubMember
      profile_path
    else
      root_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "rake #{task} #{args.join(' ')} &"
  end

end
