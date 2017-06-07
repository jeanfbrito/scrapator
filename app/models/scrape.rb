class Scrape < ApplicationRecord
  extend Enumerize
  enumerize :status, :in => {
    :unscraped => 0,
    :similar => 1,
    :changed => 2,
    :notfound = > 3
    }, default: :unscraped, scope: true
end
