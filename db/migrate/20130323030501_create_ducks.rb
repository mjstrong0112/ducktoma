class CreateDucks < ActiveRecord::Migration
  def change
    create_table :ducks do |t|
      
      t.integer :number
      t.references :adoption

      t.timestamps
    end
  end
end
