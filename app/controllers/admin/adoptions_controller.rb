class Admin::AdoptionsController < Admin::BaseController
  inherit_resources
  actions :index

  load_and_authorize_resource
  belongs_to :user, :optional => :true

  #before_filter :authenticate_user!, :only => :index

  def index
    ids = Adoption.paid.only(:id).map(&:id)
    @total_donations = Adoption.paid.sum(:fee)
    @total_ducks = Duck.where(:adoption_id.in => ids).count
    @adoptions = Adoption.valid.paginate(:page => params[:page] ||= 1, :per_page => 20)
  end
end
