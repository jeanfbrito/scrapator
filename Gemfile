source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# Use Rails with PostgreSQL
gem 'pg'
gem 'rails', '~> 5.0.1'
gem 'rails-settings-ui'
gem 'rails-settings-cached'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
gem "font-awesome-rails"
# FRONT-END Gems
gem 'kaminari'
gem 'simple_form'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.4'
gem 'record_tag_helper', '~> 1.0' #necessario mas precisa revisao
gem 'bootstrap-generators', '~> 3.3.4'

gem 'capistrano3-delayed-job'
gem 'capistrano', '~> 3.7', '>= 3.7.1'
gem 'capistrano-rails', '~> 1.2'
gem 'capistrano-passenger', '~> 0.2.0'


# Add this if you're using rbenv
gem 'capistrano-rbenv', '~> 2.1'
gem "daemons"


# Headless Chrome Gems (used to scrap data)
gem 'watir'
gem 'nokogiri'
gem 'headless'
gem 'chromedriver-helper'
gem 'delayed_job_active_record'

# Manage User login, logout, register
gem 'devise'
gem 'enumerize'

# Notify users about changes on Scraped data
gem 'telegram-bot'

# Cocoon allows nested fields with simple form
gem 'cocoon', '1.2.10'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano-rake', require: false
end
