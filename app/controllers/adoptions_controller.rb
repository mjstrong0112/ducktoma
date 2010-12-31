class AdoptionsController < ApplicationController
  inherit_resources
  actions :index, :show, :new, :create #, :edit, :update
  load_and_authorize_resource
  belongs_to :user, :optional => :true

  #before_filter :authenticate_user!, :only => :index
  def new
    unless Duck.available?
      render('home/ducks_exhausted')
    end    
  end
  def index
    @adoptions = current_user.adoptions_f(:std).paginate(:page => params[:page] ||= 1)
  end
  def create
    @adoption = Adoption.new(params[:adoption])
    @adoption.type = "std"
    @adoption.user = current_user if current_user
    create!
  end
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Please sign in to access this page'
    redirect_to new_user_session_url    
  end
end