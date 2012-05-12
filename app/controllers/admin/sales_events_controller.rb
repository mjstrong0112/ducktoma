class Admin::SalesEventsController < Admin::BaseController
  inherit_resources
  actions :index, :show

  def index
    @scope = :admin
    @sales_events = SalesEvent.all(:sort => [:date, :desc])
    index! do |format|
      format.html { render 'sales/sales_events/index' }
    end
  end

  def show
    @sales_event = SalesEvent.find(params[:id])
    @adoptions = @sales_event.adoptions.sort_by(&:adoption_number)
    show!
  end

  def move
    @sales_event = SalesEvent.new
    @adoption_numbers = params[:adoption_numbers]
    @reassignation = true
    render 'sales/sales_events/new'
  end

  def reassign
  end

end