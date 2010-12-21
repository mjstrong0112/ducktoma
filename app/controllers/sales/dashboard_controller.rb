class Sales::DashboardController < Sales::BaseController
  #load_and_authorize_resource
  def index

  end
  #belongs_to :user, :optional => :true
  #before_filter :authenticate_user!, :only => :index
  #def index
    #@adoptions = Adoption.paginate(:page => params[:page] ||= 1)
  #end
end