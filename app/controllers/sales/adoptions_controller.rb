class Sales::AdoptionsController < Sales::BaseController
  inherit_resources
  actions :index, :show, :new, :create, :edit, :update, :destroy

  load_and_authorize_resource
  belongs_to :user, :optional => :true

  #before_filter :authenticate_user!, :only => :index
  def index
    @adoptions = current_user.adoptions_f(:sales).paginate(:page => params[:page] ||= 1)
  end
  def create
    @adoption = Adoption.new(params[:adoption])
    @adoption.type = :sales
    @adoption.user = current_user if current_user
    create!
  end
  def update
    update! { sales_adoptions_url }
  end
end