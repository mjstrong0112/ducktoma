class AdoptionsController < ApplicationController

  before_filter :authenticate_user!, only: [:index]

  def index
    @adoptions = current_user.adoptions_f(:std).paginate(:page => params[:page] ||= 1)
  end

  def new
    if !Duck.available?
      render('home/ducks_exhausted')
    elsif !Settings[:adoptions_live]
      render('home/coming_soon')
    else
      @adoption      = Adoption.new
      @pricings      = Pricing.all.sort_by(&:quantity)
      @organizations = Organization.all.sort_by(&:name)

      if params[:referer] && !params[:no_referer]
        @referer = ClubMember.find params[:referer]
      elsif current_club_member && current_club_member.creditable? && !params[:no_referer]
        @referer = current_club_member
      end
    end
  end

  def show
    # search for adoption on either id or adoption number
    if params[:id]
      @adoption = Adoption.find(params[:id])
    elsif params[:adoption_number]
      @adoption = Adoption.where(:number => params[:adoption_number]).first
    end

    authorize! :show, @adoption

    if @adoption.nil?
      flash[:alert] = "Adoption could not be found"
      redirect_to root_url
    end
  end

  # TODO: Add error handling.
  def associate
    @adoption = Adoption.find params[:id]
    @adoption.club_member = ClubMember.find params[:user_id]
    @adoption.save!
    redirect_to edit_adoption_url @adoption
  end


  def edit
    @adoption = Adoption.find(params[:id])
    if @adoption.state == 'new' || @adoption.state == 'associate'
      # If this organiztion has individuals,
      # display intermediate page to show individual orders.
      # Otherwise, jump directly to paypal.
      if !@adoption.club_member && @adoption.club.try(:club_members).try(:count).to_i > 0 && !params[:skip_association]
        render 'associate'
        @adoption.state = 'associate'
        @adoption.save!
      else
        render 'confirm', :layout => 'barebones'
        @adoption.state =  'pending'
        @adoption.save!
      end

    elsif @adoption.state == 'pending'
      render('pending')
    elsif @adoption.state == 'completed'
      render('completed')
    elsif @adoption.state == 'canceled'
      render('canceled')
    end
  end

  def create
    @adoption = Adoption.new(params[:adoption])
    @adoption.type = "std"
    # TODO: Need a better way to handle this association.
    @adoption.user = current_user if current_user && !current_user.is?(:facebook)
    if @adoption.ducks_available?
      if @adoption.save
        redirect_to edit_adoption_url(@adoption.id)
      else
        # TODO: Reduce duplication (duplicated from new)
        @pricings      = Pricing.all.sort_by(&:quantity)
        @organizations = Organization.all.sort_by(&:name)
        render 'new'
      end
    else
      flash[:alert] = 'There are only ' + (Settings[:duck_inventory]-Duck.valid_count).to_s +
                        ' ducks left. You tried to adopt ' + @adoption.duck_count.to_s + ' ducks'
      redirect_to new_adoption_url
    end
  end

end