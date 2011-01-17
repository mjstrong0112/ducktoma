class Admin::LocationsController < ApplicationController
  inherit_resources
  load_and_authorize_resource
  actions :index, :new, :create, :destroy
  create! { admin_locations_url }
end
