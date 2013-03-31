class CreatePricings < ActiveRecord::Migration
  def change
    create_table :pricings do |t|
      t.decimal :price
      t.integer :quantity

      t.timestamps
    end
  end
end
