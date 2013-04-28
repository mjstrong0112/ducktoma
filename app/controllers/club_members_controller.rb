class ClubMembersController < ApplicationController
  respond_to :html, :js

  def show
    @user = ClubMember.find(params[:id] || current_club_member)
    if @user.is?(:leader)
      @pending = @user.organization.club_members.where(role: "member", approved: false)

      @new_member = ClubMember.new
      @new_member.organization = @user.organization
    end

    render_show
  end

  def new
    @user = ClubMember.new(organization_id: current_club_member.organization.id)
  end


  def create    
    @user = ClubMember.new params[:club_member]
    @user.approved = true
    @user.organization = current_club_member.organization
    if @user.update_attributes(params[:club_member])
      flash[:notice] = "#{@user.name} has been updated successfully!"      
      redirect_to profile_url
    else            
      render 'new'
    end
  end

  def update    
    @user = ClubMember.find params[:id]
      
    if params[:club_member][:password].blank?
      params[:club_member].delete("password")
      params[:club_member].delete("password_confirmation")
    end

    if @user.update_attributes(params[:club_member])
      flash[:notice] = "Your profile has been updated successfully!"      
    else
      flash[:alert] = "We could not update your profile. Please try again later."            
    end

    redirect_to profile_url
  end

  def approve
    @user = ClubMember.find params[:id]    
    if @user.update_attributes(approved: true)
      redirect_to profile_path, :notice => "User approved successfully!"      
    else
      redirect_to profile_path, :alert => "User could not be approved."
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

  def load_leader_info
  end


  def render_show
    return render('associate') if not @user.organization
    if @user.approved || @user.is?(:leader)
      render 'show'
    else
      render 'need_approval'
    end
  end

end