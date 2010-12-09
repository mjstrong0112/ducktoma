module Sales
  class Sales::AdoptionsController < BaseController
    inherit_resources
    actions :index, :show, :new, :create, :edit, :update

    load_and_authorize_resource
    belongs_to :user, :optional => :true

    #before_filter :authenticate_user!, :only => :index
    def index
      @adoptions = current_user.adoptions.paginate(:page => params[:page] ||= 1)
    end
    def update
      update! { sales_adoptions_url }
    end
    def delete
      redirect_to root_path
    end
  end
end