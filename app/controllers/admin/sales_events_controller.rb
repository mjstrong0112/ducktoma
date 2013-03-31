class Admin::SalesEventsController < Admin::BaseController

  def index
    @scope = :admin
    @sales_events = SalesEvent.order("date desc")
    respond_to do |format|
      format.html { render 'sales/sales_events/index' }
    end
  end

  def show
    @sales_event = SalesEvent.find(params[:id])
    @adoptions = @sales_event.adoptions.sort_by(&:adoption_number)    
  end

  def move
    @sales_event = SalesEvent.new
    @adoption_numbers = params[:adoption_numbers]
    @reassignation = true
    render 'sales/sales_events/new'
  end

end