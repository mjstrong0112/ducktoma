class AdoptionsController < ApplicationController
  inherit_resources

  belongs_to :user, :optional => :true

  before_filter :authenticate_user!, :only => :index
  
  def show
    @adoption = Adoption.find(params[:id])
    
    #Fake adoption
    #@adoption = Adoption.new
    #@adoption.raffle_number = "M25919385919401"
  end
end