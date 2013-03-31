class CreateSettings < ActiveRecord::Migration
  def change
    create_table(:settings) do |t|
      t.boolean :adoptions_live
      t.integer :duck_inventory
    end
  end
end
