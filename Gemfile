source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Rails core
gem "rails", "~> 8.0.0"
gem "sprockets-rails"
gem "sqlite3"
gem "puma", "~> 6.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Frontend
gem "importmap-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "jbuilder"
gem 'bootstrap', '~> 5.3'
gem 'jquery-rails'
gem 'sassc-rails'
gem 'popper_js', '~> 2.11'

# Authentication & Authorization
gem 'devise', '~> 4.9'
gem 'devise-i18n', '~> 1.11'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection', '~> 1.0'

# UI Components
gem "simple_calendar"
gem 'pagy', '~> 6.0'
gem 'chartkick', '~> 5.0'
gem 'groupdate'

# File Processing
gem "image_processing", "~> 1.2"

# API & Data
gem 'faraday', '~> 2.7'
gem 'icalendar'
gem 'phonelib'

# Utilities
gem 'whenever', '~> 1.0', require: false
gem 'dotenv-rails'
gem 'rails-i18n'
gem 'erb-formatter'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem "web-console"
  gem "capistrano"
  gem "capistrano-rails"
  gem 'capistrano-rvm'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'brakeman', require: false
  gem 'bullet'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers", "= 5.3.1"
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
end