class Admin::LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @locations = Location.order "name asc"
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new params[:location]
    if @location.save
      redirect_to admin_locations_url, :notice => "Location created successfully!"
    else
      render 'new'
    end
  end

  def edit
    @location = Location.find params[:id]
  end

  def update
    @location = Location.find params[:id]
    if @location.update_attributes params[:location]
      redirect_to admin_locations_url, :notice => "Location updated successfully!"
    else
      render 'edit'
    end
  end

  def destroy
    @location = Location.find params[:id]
    if @location.destroy
      redirect_to admin_locations_url, :notice => "Location destroyed successfullly!"
    else
      redirect_to admin_locations_url, :alert => "Could not destroy location."
    end
  end

end
