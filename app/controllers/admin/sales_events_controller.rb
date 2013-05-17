class Admin::SalesEventsController < Admin::BaseController
  sortable_for :adoption
  respond_to :html

  def index
    @scope = :admin
    @sales_events = SalesEvent.order("date desc")
    respond_to do |format|
      format.html { render 'sales/sales_events/index' }
    end
  end

  def show
    @sales_event = SalesEvent.find(params[:id])
    @adoptions = @sales_event.adoptions.includes(:adopter_info, :user)
                             .sort(sort_column, sort_direction)
  end

  def edit
    @sales_event = SalesEvent.find(params[:id])    
  end

  def update
    @sales_event = SalesEvent.find params[:id]
    flash[:notice] = "Sales Event updated successfully" if @sales_event.update_attributes params[:sales_event]
    respond_with(:admin, @sales_event)
  end

  def move
    @sales_event = SalesEvent.new
    @adoption_numbers = params[:adoption_numbers]
    @reassignation = true
    render 'sales/sales_events/new'
  end

end