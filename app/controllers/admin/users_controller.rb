class Admin::UsersController < Admin::BaseController
  inherit_resources
  load_and_authorize_resource
  actions :index, :new, :create, :edit, :update, :destroy
  #before_filter :authenticate_user!, :only => :index
  def index
    @users = User.paginate(:page => params[:page] ||= 1)
  end
  def update
    user_params = params[:user]
    user_params[:password] = user_params[:password_confirmation] = nil if user_params[:password].blank? &&
                                                                          user_params[:password_confirmation].blank?
    update! { admin_users_path }
  end
end

