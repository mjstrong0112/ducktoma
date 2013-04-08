class OmniauthUsersController < ApplicationController

  def show
    @user = OmniauthUser.find params[:id]
    render_show
  end

  def update
    @user = OmniauthUser.find params[:id]
    o = Organization.find params[:omniauth_user][:organization_id]
    @user.organization = o

    if @user.save
      flash[:notice] = "Your profile has been updated successfully!"
      render_show
    else
      flash.now[:alert] = "We could not associate you to this organization. Please try again later."      
      render_show
    end
  end

private

  def render_show
    @user.organization ? render('show') : render('associate')
  end

end
