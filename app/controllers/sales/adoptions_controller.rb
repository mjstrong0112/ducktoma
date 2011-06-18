class Sales::AdoptionsController < Sales::BaseController
  inherit_resources
  actions :all
  load_and_authorize_resource
  belongs_to :sales_event, :optional => :true

  def index
    @adoptions = current_user.adoptions.sales
                  .paginate(:page => params[:page] ||= 1, :per_page => 20)
  end

  #def show
  #  @adoption = Adoption.find(params[:id])
  #  authorize! :show, @adoption
  #end

  def edit    
    edit!
    #@adoption = Adoption.find(params[:id])
  end

  def update
    @adoption = Adoption.find(params[:id])
  end

  def create
    unless parent?
      @adoption = Adoption.new(params[:adoption])
      @adoption.type = :sales
      @adoption.user = current_user if current_user
      create! { new_sales_adoption_url }
    else    
      @sales_event = SalesEvent.find(params[:sales_event_id])

      @adoption = Adoption.new(params[:adoption])
      @adoption.type = :sales
      @adoption.user = current_user if current_user

      @sales_event.adoptions.build(@adoption)
      
      create! { new_sales_sales_event_adoption_url }
    end    
  end

  update! { sales_adoptions_url }

  protected
  #def begin_of_association_chain
  #  parent? ? parent : current_user
  #end
  def collection
    @adoptions ||= end_of_association_chain.where(:type => "sales").paginate(:page => params[:page] || 1)
  end
end