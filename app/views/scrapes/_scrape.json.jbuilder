json.extract! scrape, :id, :name, :url, :xpath, :config_value, :read_value, :status, :last_read, :created_at, :updated_at
json.url scrape_url(scrape, format: :json)
