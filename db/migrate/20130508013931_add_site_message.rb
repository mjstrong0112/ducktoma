class AddSiteMessage < ActiveRecord::Migration
  def change
    add_column :settings, :canned_site_message, :string, default: "member"
    add_column :settings, :custom_site_message, :text, default: "member"
  end
end
