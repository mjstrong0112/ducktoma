class CreateOmniauthUsers < ActiveRecord::Migration
  def change
    create_table :omniauth_users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :oauth_token
      t.string :picture_url
      t.time :oauth_expires_at
      t.references :organization

      t.timestamps
    end
    add_index :omniauth_users, :organization_id
  end
end
