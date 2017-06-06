class CreateScrapes < ActiveRecord::Migration[5.0]
  def change
    create_table :scrapes do |t|
      t.string :name
      t.text :url
      t.string :xpath
      t.text :config_value
      t.text :read_value
      t.integer :status
      t.datetime :last_read

      t.timestamps
    end
  end
end
