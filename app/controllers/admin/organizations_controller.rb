class Admin::OrganizationsController < ApplicationController
  inherit_resources
  load_and_authorize_resource
  actions :index, :new, :create, :destroy, :edit, :update
  create! { admin_organizations_url }
  update! { admin_organizations_url }
  def index
    @organizations = Organization.asc(:name)
    @organization_values = {}
    @organizations.group_by(&:name).each do |name, arr|
      @organization_values[name] = {
                    total_ducks: find_total_ducks_by_organization(name),
                    total_donations: find_total_fee_by_organization(name)
                                    }
    end
  end
end
