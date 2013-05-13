class AddPermitMembersFlag < ActiveRecord::Migration
  def change
    add_column :organizations, :permit_members, :boolean, default: false
  end
end
