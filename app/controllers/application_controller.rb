class ApplicationController < ActionController::Base
  include InheritedResources::DSL
  include ::SslRequirement
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  protect_from_forgery

end
