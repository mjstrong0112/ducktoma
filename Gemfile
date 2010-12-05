source 'http://rubygems.org'

gem 'rack-contrib', :require => 'rack/contrib'
gem 'rails', '3.0.3'

gem 'will_paginate'

# Core Ext
gem 'andand', :git => "git://github.com/raganwald/andand.git"

# UI
gem 'haml', '~> 3.0.21'
gem 'simple_form', '~> 1.2.2'
gem 'compass', '~> 0.10.6'

# Temp gems
gem 'placeholder', '~> 0.0.6'

# Controller
gem 'inherited_resources', '~> 1.1.2'

# Auth
gem 'devise', '~> 1.1.3'
# DB
gem 'mongoid', '~> 2.0.0.beta.20'
# Bson and bson_ext have to be the same version
gem 'bson', '~> 1.1.2'
gem 'bson_ext', '~> 1.1.2'

# Test gems without generators
group :test do
  gem 'rr', '~> 1.0.2'
  gem 'capybara', '~> 0.4.0'
  gem 'launchy', '~> 0.3.7'
  gem 'webrat', '~> 0.7.2', :require => nil
  gem 'azebiki', '~> 0.0.2', :require => nil
  gem 'forgery', '~> 0.3.6'
  gem 'database_cleaner', '~> 0.6.0'
  gem 'remarkable_activemodel', '~> 4.0.0.alpha4', :require => nil
  gem 'remarkable_mongoid', '~> 0.5.0', :require => nil
  #gem 'mongoid-rspec', '~> 1.2.1'
  #gem 'webmock', '~> 1.3.5'
  gem 'timecop', '~> 0.3.5'
  gem 'test_notifier', '~> 0.3.6'
  gem 'autotest', '~> 4.4.5'
end

# Test gems with generators (available in dev env)
group :development, :test do
  gem 'rspec-core', '~> 2.1.0'
  gem 'rspec-expectations', '~> 2.1.0'
  gem 'rspec-rails', '~> 2.1.0'
  gem 'steak', '>= 1.0.0.rc.4'

  gem 'spork', '>= 0.9.0.rc2'
end

# Special gems that get reloaded by spork on each run ( no auto require ) (Microoptimization)
gem 'fabrication', '~> 0.9.0', :require => nil, :group => :test
gem 'fabrication', '~> 0.9.0', :group => :development

group :development do
  # UI
  gem 'flutie', '~> 1.1.2'

  # Servers
  #gem 'mongrel', '>= 1.2.0.pre2'
  gem 'thin', '~> 1.2.7'
  #gem 'unicorn'

  # Utilities
  gem 'rails3-generators', '~> 0.14.0'
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'
