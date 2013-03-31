class CreatePaymentNotification < ActiveRecord::Migration
  def change
    create_table(:payment_notifications) do |t|      
      t.string :transaction_id
      t.string :invoice
      t.string :status
      t.string :state, :default => "new"
      t.string :params
      t.timestamps
    end
  end
end
