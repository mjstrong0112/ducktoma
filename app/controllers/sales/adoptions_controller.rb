class Sales::AdoptionsController < Sales::BaseController
  load_and_authorize_resource
  #belongs_to :sales_event, :optional => :true

  def index
    @adoptions = current_user.adoptions.sales.paginate(:page => params[:page] ||= 1, :per_page => 20)
  end

  def new
    @sales_event = SalesEvent.find(params[:sales_event_id]) if params[:sales_event_id]
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
      @club_members = @sales_event.organization.club_members
    end
  end

  def update
    @adoption = Adoption.find params[:id]
    if @adoption.update_attributes params[:adoption]
      redirect_to sales_adoptions_url, :notice => "Adoption updated successfully!"
    else
      render 'edit'
    end
  end

  def create
    if parent?
      @sales_event = SalesEvent.find(params[:sales_event_id])
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
    params[:sales_event_id] # || params[:sales_event]
  end

  def collection
    @adoptions ||= end_of_association_chain.where(:type => "sales").paginate(:page => params[:page] || 1)
  end
end