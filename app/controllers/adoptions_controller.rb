class AdoptionsController < ApplicationController

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


  def edit
    @adoption = Adoption.find(params[:id])
    if @adoption.state == 'new'
      render 'confirm', :layout => 'barebones'
      @adoption.state =  'pending'
      @adoption.save!
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
    @adoption.user = current_user if current_user
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