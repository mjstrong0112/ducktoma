module Sales
  class BaseController < ApplicationController
    before_filter :authenticate_user!
    def current_ability
      @current_ability ||= SalesAbility.new(current_user)
    end
    rescue_from CanCan::AccessDenied do |exception|
      flash[:alert] = "You are not authorized to view this page."
      redirect_to root_url
    end
  end
end