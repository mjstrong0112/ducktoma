class AdoptionsController < ApplicationController
  inherit_resources
  actions :all, :except => [:show]
  belongs_to :user, :optional => :true
  load_and_authorize_resource :except => [:show]
  #before_filter :authenticate_user!, :only => :index
  
  def new
    if !Duck.available?
      render('home/ducks_exhausted')
    elsif !Settings[:adoptions_live]
      render('home/coming_soon')
    else
      @pricings = Pricing.all.sort_by { |p| p.quantity }
      new!
    end
  end
  def show
    # search for adoption on either id or adoption number
    if params[:id]
      @adoption = Adoption.find(params[:id])
    elsif params[:adoption_number]
      @adoption = Adoption.where(:adoption_number => params[:adoption_number]).first
      raise Mongoid::Errors::DocumentNotFound.new(Adoption, params[:adoption_number]) if @adoption.nil?
    end
    
    authorize! :show, @adoption
  rescue Mongoid::Errors::DocumentNotFound
    flash[:alert] = "Adoption could not be found"
    redirect_to root_url
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
  def index
    @adoptions = current_user.adoptions_f(:std).paginate(:page => params[:page] ||= 1)
  end
  
  def create
    @adoption = Adoption.new(params[:adoption])
    @adoption.type = "std"
    @adoption.user = current_user if current_user
    if @adoption.ducks_available?
      #Can't seem to get inherited resources to use no notice
      #create! { edit_adoption_url(@adoption.id)}
      if @adoption.save
        redirect_to edit_adoption_url(@adoption.id)
      else         
        render('new')
      end
    else
      flash[:alert] = 'There are only ' + (Settings[:duck_inventory]-Duck.valid_count).to_s +
                        ' ducks left. You tried to adopt ' + @adoption.duck_count.to_s + ' ducks'
      redirect_to new_adoption_url
    end
  end
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Please sign in to access this page'
    redirect_to new_user_session_url    
  end
end