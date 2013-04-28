class ChangeParamsToText < ActiveRecord::Migration
  def change
    change_column :payment_notifications, :params, :text, :limit => nil
  end
end
