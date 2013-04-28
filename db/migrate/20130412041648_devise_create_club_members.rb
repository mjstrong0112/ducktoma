class DeviseCreateClubMembers < ActiveRecord::Migration
  def change
    create_table(:club_members) do |t|

      t.string :name
      t.string :picture_url
      t.references :organization

      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      # Omniauth Fields.
      t.string :provider
      t.string :uid      
      t.string :oauth_token      
      t.time :oauth_expires_at    

      t.timestamps
    end

    add_index :club_members, :email,                :unique => true
    add_index :club_members, :reset_password_token, :unique => true
  end
end
