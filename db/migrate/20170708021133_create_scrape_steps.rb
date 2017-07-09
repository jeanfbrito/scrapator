class CreateScrapeSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :scrape_steps do |t|
      t.references :scrape, index: true
      t.string :title, null: false, default: ''
      t.string :xpath, null: false, default: ''
      t.string :option, default: ''
      t.string :value, null: false, default: ''

      t.timestamps
    end
  end
end
