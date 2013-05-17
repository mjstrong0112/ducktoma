source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'devise'
gem 'cancan'
gem 'haml'
gem "haml-rails"
gem 'bourbon'
gem 'simple_form'
gem 'pry'
gem 'pry-stack_explorer'
gem 'will_paginate', '~> 3.0'
gem 'carmen'
gem 'letter_opener'
gem 'acts_as_singleton'
gem 'omniauth-facebook', '1.4.0'
gem 'koala'
gem 'carrierwave'
gem 'fog'
gem 'jquery-rails'
gem 'rails_admin'

# Heroku requires postgres.
group :production  do
  gem "pg"
  gem 'therubyracer-heroku', '0.8.1.pre3'
end

group :development do
  gem 'sqlite3'
  gem 'quiet_assets'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'forgery', '0.5.0'
end