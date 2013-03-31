class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|

      t.string :full_name
      t.string :email
      t.string :phone
      t.string :city 
      t.string :address
      t.string :state
      t.string :zip

      t.string :contact_type
      t.references :contact

      t.timestamps
    end
  end
end
