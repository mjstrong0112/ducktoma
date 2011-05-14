class Admin::AdoptionsController < Admin::BaseController
  inherit_resources
  load_and_authorize_resource
  belongs_to :user, :optional => :true
  #before_filter :authenticate_user!, :only => :index
  def index
    @adoptions = Adoption.valid.paginate(:page => params[:page] ||= 1)
  end
end
