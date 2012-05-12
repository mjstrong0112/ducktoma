class Sales::SalesEventsController < Sales::BaseController
  inherit_resources
  actions :index, :new, :create, :edit, :update, :destroy, :show
  load_and_authorize_resource
  def index
    @sales_events = current_user.sales_events
  end
  def create
    @sales_event = SalesEvent.where(params[:sales_event]).first
    unless params[:adoption_numbers]
      unless @sales_event
        create! { new_sales_sales_event_adoption_path(@sales_event) }
      else
        redirect_to new_sales_sales_event_adoption_path(@sales_event)
      end
    else
      # If this is a reassignation
      # Create sales event if necessary
      if @sales_event.nil?
        @sales_event = SalesEvent.create!(params[:sales_event])
      end

      adoption_numbers = params[:adoption_numbers].split(',')
      adoptions = Adoption.where(:adoption_number.in => adoption_numbers).to_a
      adoptions.each do |adoption|
         adoption.update_attributes(:sales_event_id => @sales_event.id)
      end

      redirect_to admin_sales_events_url, :notice => "Reassign completed successfuly!"
    end
  end
end
