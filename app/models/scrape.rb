class Scrape < ApplicationRecord
  extend Enumerize

  belongs_to :user

  has_many :scrape_steps, dependent: :destroy, inverse_of: :scrape

  accepts_nested_attributes_for :scrape_steps, allow_destroy: true
  
  validates :name, :url, :xpath, :config_value, :user_id, presence: true

  enumerize :status, in: {
    unscraped: 0,
    similar: 1,
    changed: 2,
    notfound: 3
  }, default: :unscraped, scope: true
end
