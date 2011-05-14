class Admin::OrganizationsController < ApplicationController
  inherit_resources
  load_and_authorize_resource
  actions :index, :new, :create, :destroy, :edit, :update
  create! { admin_organizations_url }
  update! { admin_organizations_url }
  def index
    @organizations = Organization.asc(:name)
  end
end
