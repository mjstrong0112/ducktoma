class Admin::AdoptionsController < ApplicationController
  inherit_resources
  
  belongs_to :user, :optional => :true

  before_filter :authenticate_user!, :only => :index
  def index
    @adoptions = Adoption.paginate(:page => params[:page] ||= 1)
  end
end
