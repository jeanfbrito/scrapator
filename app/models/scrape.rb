class Scrape < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :name, :url, :xpath, :config_value, :user_id, presence: true

  enumerize :status, in: {
    unscraped: 0,
    similar: 1,
    changed: 2,
    notfound: 3
  }, default: :unscraped, scope: true
end
