class Sales::BaseController < ApplicationController
  before_filter :authenticate_user!, :verify_sales
  def current_ability
    @current_ability ||= SalesAbility.new(current_user)
  end
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "You are not authorized to view this page."
    redirect_to root_url
  end
  private
  def verify_sales
    unless current_user.is?(:sales) || current_user.admin?
      flash[:alert] = "You are not authorized to view this page."
      redirect_to root_url
    end
  end
end