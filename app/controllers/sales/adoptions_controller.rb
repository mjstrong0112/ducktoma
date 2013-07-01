class Sales::AdoptionsController < Sales::BaseController
  load_and_authorize_resource
  sortable_for :adoption
  before_filter :load_sales_event
  respond_to :html

  def index
    @adoptions = current_user.adoptions.sales
                             .with_duck_count
                             .sort(sort_column, sort_direction)
                             .paginate(:page => params[:page] ||= 1, :per_page => 20)
  end

  def new
    @adoption = Adoption.new
    @club_members = @sales_event.organization.club_members
  end


  def show
    @adoption = Adoption.find params[:id]
  end

  def edit
    @adoption = Adoption.find params[:id]
    @sales_event = @adoption.sales_event
    if @sales_event
      @club_members = @sales_event.organization.club_members || []
    end
  end

  def update
    @adoption = Adoption.find params[:id]
    flash[:notice] = "Adoption updated successfully!" if @adoption.update_attributes(params[:adoption])
    respond_with(@adoption)
  end

  def create
    if parent?
      @adoption = @sales_event.adoptions.build params[:adoption]
    else
      @adoption = Adoption.new(params[:adoption])
    end

    @adoption.sales_type = :sales
    @adoption.user = current_user if current_user

    if @adoption.save
      redirect_to new_sales_sales_event_adoption_url, :notice => "Adoption created successfully!"
    else
      render 'new'
    end
  end

  def destroy
    @adoption = Adoption.find params[:id]
    if @adoption.destroy
      redirect_to admin_locations_url, :notice => "Adoption destroyed successfullly!"
    else
      redirect_to admin_locations_url, :alert => "Could not destroy adoption."
    end
  end

protected

  def parent?
    params[:sales_event_id]
  end

  def load_sales_event
    @sales_event = SalesEvent.find params[:sales_event_id] if params[:sales_event_id]
  end

  def collection
    @adoptions ||= end_of_association_chain.where(:type => "sales").paginate(:page => params[:page] || 1)
  end
end