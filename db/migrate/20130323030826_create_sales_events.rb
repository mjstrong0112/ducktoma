class CreateSalesEvents < ActiveRecord::Migration
  def change
    create_table :sales_events do |t|
      
      t.date :date
      t.references :organization
      t.references :location

      t.timestamps
    end
  end
end
