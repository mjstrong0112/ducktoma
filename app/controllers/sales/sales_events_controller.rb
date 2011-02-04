class Sales::SalesEventsController < Sales::BaseController
  inherit_resources
  actions :index, :new, :create, :edit, :update, :destroy, :show
  load_and_authorize_resource
  def index
    @sales_events = current_user.sales_events
  end
  def create
    @sales_event = SalesEvent.where(params[:sales_event]).first
    unless @sales_event
      create! { new_sales_sales_event_adoption_path(@sales_event) }
    else
      redirect_to new_sales_sales_event_adoption_path(@sales_event)
    end
  end

end
