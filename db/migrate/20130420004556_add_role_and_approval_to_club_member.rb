class AddRoleAndApprovalToClubMember < ActiveRecord::Migration
  def change
    add_column :club_members, :role, :string, default: "member"
    add_column :club_members, :approved, :boolean, default: false
  end
end
