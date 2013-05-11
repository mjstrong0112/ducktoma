class RemoveNullEmailConstraint < ActiveRecord::Migration
  def change
    change_column :club_members, :email, :string, :null => true, :default => nil
  end
end
