module Admin
  class ClubMembersController < ApplicationController

    def index
      @leaders = ClubMember.leaders.paginate(:page => params[:page] ||= 1, :per_page => 20)
    end

    def new
      @user = ClubMember.new
    end

    def edit
      @user = ClubMember.find params[:id]
    end

    def create
      @user = ClubMember.new params[:club_member]
      @user.approved = true
      @user.organization.try(:allow_members!)
      if @user.save
        redirect_to admin_club_members_path, :notice => "Club Member created successfully!"
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

      if @user.update_attributes params[:club_member]
        redirect_to admin_club_members_path, :notice => "Club Member updated successfully!"
      else
        render 'edit'
      end

    end

  end
end