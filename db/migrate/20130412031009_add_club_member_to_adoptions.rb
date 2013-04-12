class AddClubMemberToAdoptions < ActiveRecord::Migration
  def change
    add_column :adoptions, :club_member_id, :integer
  end
end
