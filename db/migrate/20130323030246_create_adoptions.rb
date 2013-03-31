class CreateAdoptions < ActiveRecord::Migration
  def change
    create_table :adoptions do |t|

      t.string  :number
      t.integer :fee
      t.string  :sales_type
      t.string  :state, :default => "new"

      t.references :user
      t.references :sales_event
      t.references :club
      t.references :payment_notification

      t.timestamps
    end
  end
end
