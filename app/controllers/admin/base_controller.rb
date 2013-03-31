class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!, :verify_admin
  
  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "You are not authorized to view this page."
    redirect_to root_url
  end

private

  def verify_admin
    unless current_user.admin?
      flash[:alert] = "You are not authorized to view this page."
      redirect_to root_url
    end
  end

end
    