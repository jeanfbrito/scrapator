Rails.application.routes.draw do
  resources :scrapes do
    member do
      post "scrape", to: "scrapes#scrape", as: "scrape"
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
