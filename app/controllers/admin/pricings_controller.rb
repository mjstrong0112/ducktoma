class Admin::PricingsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @pricings = Pricing.order("quantity desc")
  end

  def new
    @pricing = Pricing.new
  end

  def create
    @pricing = Pricing.new params[:pricing]
    if @pricing.save
      redirect_to admin_pricings_url, :notice => "Pricing created successfully!"
    else
      render 'new'
    end
  end

  def edit
    @pricing = Pricing.find params[:id]
  end

  def update
    @pricing = Pricing.find params[:id]
    if @pricing.update_attributes params[:pricing]
      redirect_to admin_pricings_url, :notice => "Pricing updated successfully!"
    else
      render 'edit'
    end
  end

  def destroy
    @pricing = Pricing.find params[:id]
    if @pricing.destroy
      redirect_to admin_pricings_url, :notice => "Pricing destroyed successfullly!"
    else
      redirect_to admin_pricings_url, :alert => "Could not destroy pricing."
    end
  end

protected
  def collection
    @pricings ||= end_of_association_chain.desc :quantity
  end
end

