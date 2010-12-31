class Admin::SettingsController < Admin::BaseController
  inherit_resources
  actions :edit, :update
  defaults :class_name => "Settings", :instance_name => "settings"

  update! { edit_admin_settings_url }

  protected
  def resource
    @settings ||= Settings.instance
  end
end