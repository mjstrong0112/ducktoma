class Admin::OrganizationsController < ApplicationController
  load_and_authorize_resource

  def index
    @organizations = Organization.order("name asc")
    @organization_values = {}
    @organizations.each do |o|
      @organization_values[o.name] = {
                    total_ducks: find_total_ducks_by_organization(o),
                    total_donations: find_total_fee_by_organization(o)
                                    }
    end
    @virtual_sales = virtual_org_sales
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new params[:organization]
    if @organization.save
      redirect_to admin_organizations_url, :notice => "Organization created successfully!"
    else
      render 'new'
    end
  end

  def edit
    @organization = Organization.find params[:id]
  end

  def update
    @organization = Organization.find params[:id]
    if @organization.update_attributes params[:organization]
      redirect_to admin_organizations_url, :notice => "Organization updated successfully!"
    else
      render 'edit'
    end
  end

  def destroy
    @organization = Organization.find params[:id]
    if @organization.destroy
      redirect_to admin_organizations_url, :notice => "Organization destroyed successfully!"
    else
      redirect_to admin_organizations_url, :alert => "Could not destroy location."
    end
  end

private
  # All sales that don't belong to any organization are combined into one
  # "virtual" group.
  def virtual_org_sales
    {
     total_donations: Adoption.paid.includes(:sales_event).where(sales_events: {organization_id: nil}, club_id: nil).sum(&:fee),
     total_ducks: Duck.paid.includes(adoption: :sales_event).where(sales_events: {organization_id: nil}, adoptions: {club_id: nil}).count
    }
  end

end