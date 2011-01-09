class AdoptionsController < ApplicationController
  inherit_resources
  actions :index, :show, :new, :create, :edit, :update
  load_and_authorize_resource
  belongs_to :user, :optional => :true

  #before_filter :authenticate_user!, :only => :index
  def new
    if !Duck.available?
      render('home/ducks_exhausted')
    elsif !Settings[:adoptions_live]
      render('home/coming_soon')
    else
      new!
    end
  end
  def edit
    @adoption = Adoption.find(params[:id])
    if @adoption.state == 'new'
      render('confirm')
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
      create! { edit_adoption_url(@adoption.id) }
    else
      flash[:alert] = 'There are only ' + Settings[:duck_inventory].to_s +
                        ' ducks left. You tried to adopt ' + @adoption.duck_count.to_s + ' ducks'
      redirect_to new_adoption_url
    end
  end
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Please sign in to access this page'
    redirect_to new_user_session_url    
  end
end