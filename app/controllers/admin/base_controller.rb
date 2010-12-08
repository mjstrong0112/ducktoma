module Admin
  class BaseController < ApplicationController
    def current_ability
      @current_ability ||= AdminAbility.new(current_user)
    end
    rescue_from CanCan::AccessDenied do |exception|
      if !user_signed_in?
        flash[:error] = 'Please sign in to access this page'
        redirect_to new_user_session_url
      else
        flash[:error] = 'You cannot access this page'
        redirect_to root_url
      end
    end
  end
end