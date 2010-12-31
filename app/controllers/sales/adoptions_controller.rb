class Sales::AdoptionsController < Sales::BaseController
  inherit_resources
  actions :index, :show, :new, :create, :edit, :update, :destroy

  load_and_authorize_resource
  belongs_to :user, :optional => :true

  #before_filter :authenticate_user!, :only => :index
  def create
    @adoption = Adoption.new(params[:adoption])
    @adoption.type = :sales
    @adoption.user = current_user if current_user
    create!
  end

  update! { sales_adoptions_url }

  protected
  def begin_of_association_chain
    parent? ? parent : current_user
  end
  def collection
    @adoptions ||= end_of_association_chain.where(:type => "sales").paginate(:page => params[:page] || 1)
  end
end