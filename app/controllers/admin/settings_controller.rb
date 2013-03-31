class Admin::SettingsController < Admin::BaseController  

  def edit
    authorize! :edit, Settings
    @settings = Settings.instance
  end

  def update
    Settings.instance.update_attributes params[:settings]
    redirect_to admin_root_url, :notice => "Settings updated succesfully."
  end

end