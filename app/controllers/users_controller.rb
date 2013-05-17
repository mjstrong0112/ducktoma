class UsersController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  
  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    to_sign_in = current_user.try(:id) == @user.id
    flash[:notice] = "Password updated successfully!" if @user.update_attributes params[:user]
    sign_in(@user, :bypass => true) if to_sign_in && @user.errors.count == 0
    respond_with(@user, location: @user.admin? ? admin_root_path : sales_root_path)
  end

end