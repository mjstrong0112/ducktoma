class ClubMembersController < ApplicationController
  respond_to :html, :js

  def show
    @user = ClubMember.find(params[:id] || current_user)
    render_show
  end

  def update
    @user = ClubMember.find params[:id]
    o = Organization.find params[:club_member][:organization_id]
    @user.organization = o

    if @user.save
      flash[:notice] = "Your profile has been updated successfully!"
      render_show
    else
      flash.now[:alert] = "We could not associate you to this organization. Please try again later."      
      render_show
    end
  end

  def share_to_wall
    @user = ClubMember.find params[:id]

    @user.facebook.put_wall_post("Hello there! DESCRIPTION GOES IN HERE.", {
      "name" => "Adopt a Duck for #{@user.organization.name}",
      "link" => "http://rrsertoma.heroku.com/",
      "caption" => "#{@user.name} is asking for your help to save the world from diarrhea.",
      "description" => "This is a longer description of the attachment. We help save blahblahblah yadda yadda. This is WIP and text will be updated.",
      "picture" => "http://rrsertoma.heroku.com/images/logo.png"
    })

  end

  def autocomplete_name    
    @users = ClubMember.where("name LIKE ?", "%#{params[:name]}%")
  end


private

  def render_show
    @user.organization ? render('show') : render('associate')
  end

end
