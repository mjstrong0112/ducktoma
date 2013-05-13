class ClubMembersController < ApplicationController
  respond_to :html, :js


  def index
     # TODO: Figure out if we can get this to not load all club members.
     @club_members = ClubMember.all.sort_by(&:total)[0..9]
  end
  
  def show
    @user = ClubMember.find(params[:id] || current_club_member)
    if @user.is?(:leader)
      # TODO: Create scopes for these
      @pending = @user.organization.club_members
                      .where(role: "member", approved: false)
                      .order('name asc')
                      .paginate(:page => params[:pending_page] ||= 1, :per_page => 20)

      @approved = @user.organization.club_members
                       .order('name asc')
                       .where(role: "member", approved: true)
                       .paginate(:page => params[:approved_page] ||= 1, :per_page => 20)

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

  def merge
    all_members = ClubMember.find_all_by_id(params[:user_ids])
    @fb_member    = all_members.find { |m| m.provider == "facebook" }
    @email_member = all_members.find { |m| m.provider.nil? }

    ClubMember.transaction do      
      # Transfer over adoptions
      @email_member.adoptions.update_all(club_member_id: @fb_member.id)

      # Copy FB details over to email account.
      @fb_member.tap do |u|
        u.email = @email_member.email if @fb_member.email.blank?
        u.encrypted_password =  @email_member.encrypted_password
      end
      @email_member.destroy
      @fb_member.save!
    end
    
    redirect_to profile_path, notice: "Merge completed successfully!"
  rescue Exception => e  
    redirect_to profile_path, alert: "Merge could not be completed. #{e}"
  end

  # TODO: Reduce code duplication here.
  def approve
    @user = ClubMember.find params[:id]    
    if @user.update_attributes(approved: true)
      redirect_to profile_path, :notice => "User approved successfully!"      
    else
      redirect_to profile_path, :alert => "User could not be approved."
    end
  end

  def unapprove
    @user = ClubMember.find params[:id]    
    if @user.update_attributes(approved: false)
      redirect_to profile_path, :notice => "User unapproved successfully!"      
    else
      redirect_to profile_path, :alert => "User could not be unapproved."
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
    # HACK: Need this until remove dependency from SQLite
    if Rails.env.production?
      @users = ClubMember.where("name ILIKE ?", "%#{params[:name]}%")
    else      
      @users = ClubMember.where("name LIKE ?", "%#{params[:name]}%")    
    end
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
