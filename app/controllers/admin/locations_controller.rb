class Admin::LocationsController < ApplicationController
  inherit_resources
  load_and_authorize_resource
  actions :index, :new, :create, :destroy, :edit, :update
  def create
    create! { admin_locations_url }
  end
  def update
    update! { admin_locations_url }
  end
  def index
    @locations = Location.asc(:name)
  end
end
