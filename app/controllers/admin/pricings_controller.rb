class Admin::PricingsController < Admin::BaseController
  inherit_resources
  load_and_authorize_resource
  actions :index, :show, :new, :create, :destroy

  create! { admin_pricings_url }
  update! { admin_pricings_url }

  protected
  def collection
    @pricings ||= end_of_association_chain.desc :quantity
  end
end

