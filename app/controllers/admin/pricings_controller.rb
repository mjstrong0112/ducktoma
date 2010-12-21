class Admin::PricingsController < Admin::BaseController
  inherit_resources
  load_and_authorize_resource
  actions :index, :show, :new, :create, :destroy
  def create
    create! { admin_pricings_url }
  end
  protected
  def collection
    @pricings ||= end_of_association_chain.desc :quantity
  end
end

