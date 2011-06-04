class Admin::AdoptionsController < Admin::BaseController
  inherit_resources
  actions :index
  
  load_and_authorize_resource
  belongs_to :user, :optional => :true

  #before_filter :authenticate_user!, :only => :index
  def index    
    @adoptions_count = Adoption.valid.count

    @total_ducks = 0
    @total_donations = 0

    Adoption.paid.each { |adoption|
      @total_ducks += adoption.duck_count
      @total_donations += adoption.fee
    }

    @adoptions = Adoption.valid.paginate(:page => params[:page] ||= 1, :per_page => 20)
  end
end
