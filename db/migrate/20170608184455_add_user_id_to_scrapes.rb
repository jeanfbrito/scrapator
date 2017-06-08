class AddUserIdToScrapes < ActiveRecord::Migration[5.0]
  def change
    add_column :scrapes, :user_id, :integer, foreign_key: true, index: true
  end
end
