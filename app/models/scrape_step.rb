class ScrapeStep < ApplicationRecord
  belongs_to :scrape, inverse_of: :scrape_steps

  validates :title, :xpath, :option, presence: true
  validates :value, presence: true, if: "option == 'select value'"
end
