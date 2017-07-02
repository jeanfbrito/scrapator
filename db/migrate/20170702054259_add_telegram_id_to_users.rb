class AddTelegramIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :telegramId, :integer, index: true
  end
end
