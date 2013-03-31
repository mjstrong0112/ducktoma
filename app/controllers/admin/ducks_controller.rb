class Admin::DucksController < ApplicationController
  load_and_authorize_resource

  def show
    @duck = Duck.where(:number => params[:number]).first
    if @duck
      @adoption = @duck.adoption
    else
      flash[:alert] = "Duck " + params[:number] + " could not be found"
     redirect_to admin_root_url      
    end
  end

  # Regenerates duck numbers.
  # NOTE: This is a very taxing operation.
  # It performs thousands of queries.
  # Use with care.
  def regenerate
    call_rake 'regen_ducks'    
    redirect_to admin_root_url, :notice => "Duck numbers regenerating!"    
  end
  
end
