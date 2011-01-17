class Admin::OrganizationsController < ApplicationController
  inherit_resources
  load_and_authorize_resource
  actions :index, :new, :create, :destroy
  create! { admin_organizations_url }
end
