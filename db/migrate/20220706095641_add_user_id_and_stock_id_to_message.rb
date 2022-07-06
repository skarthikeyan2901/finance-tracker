class AddUserIdAndStockIdToMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :user_id, :int
    add_column :messages, :stock_id, :int
  end
end
