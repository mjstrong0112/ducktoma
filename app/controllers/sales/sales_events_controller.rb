class Sales::SalesEventsController < Sales::BaseController
  load_and_authorize_resource


  def index
    @sales_events = current_user.sales_events    
  end


  def create
    date = Date.strptime(params[:sales_event][:date], "%m-%d-%Y")
    params[:sales_event][:date] = date
    params[:sales_event].delete(:location_id) if params[:sales_event][:location_id] == ""
    params[:sales_event].delete(:organization_id) if params[:sales_event][:organization_id] == ""

    @sales_event = SalesEvent.where(params[:sales_event]).first
    # Create sales event if necessary
    if @sales_event.nil?
      @sales_event = SalesEvent.create!(params[:sales_event])
    end

    # if this is a reassign operation, fork off to the
    # appropriate function
    return reassign if params[:adoption_numbers]

    redirect_to new_sales_sales_event_adoption_path(@sales_event)
  end

private

  def reassign
    adoption_numbers = params[:adoption_numbers].split(',')
    adoptions = Adoption.find_all_by_number(adoption_numbers)
    adoptions.each do |adoption|
       adoption.update_attributes(:sales_event_id => @sales_event.id)
    end
    redirect_to admin_sales_events_url, :notice => "Reassign completed successfully!"
  end

end
