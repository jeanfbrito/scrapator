class AddScreenshotsToScrapes < ActiveRecord::Migration[5.0]
  def change
    add_column :scrapes, :screenshot, :string
  end
end
