class Admin::UsersController < Admin::BaseController

  sortable_for :user
  load_and_authorize_resource

  def index
    @users = User.sort(sort_column, sort_direction).paginate(:page => params[:page] ||= 1)
  end

  def show
    @user = User.find(params[:id])
    @adoptions = @user.adoptions.paginate(:page => params[:page] ||= 1, :per_page => 20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      redirect_to admin_users_path, :notice => "User created successfully!"
    else
      render 'new'
    end
  end

  def edit
    @user = User.find params[:id]
  end
  
  def update
    user_params = params[:user]
    user_params[:password] = user_params[:password_confirmation] = nil if user_params[:password].blank? &&                                
                                                                          user_params[:password_confirmation].blank?
    @user = User.find params[:id]
    if @user.update_attributes user_params
      redirect_to admin_users_path, :notice => "User created successfully!"      
    else
      render 'edit'
    end
  end
end