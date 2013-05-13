class AddTitleToClubMember < ActiveRecord::Migration
  def change
    add_column :club_members, :title, :string
  end
end
