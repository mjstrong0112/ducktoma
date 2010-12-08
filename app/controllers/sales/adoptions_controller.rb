module Sales
  class Sales::AdoptionsController < BaseController
    inherit_resources
    actions :index, :show, :new, :create
    load_and_authorize_resource
    belongs_to :user, :optional => :true

    #before_filter :authenticate_user!, :only => :index
  end
end