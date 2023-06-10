source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem 'bootstrap', '~> 5.3.0.alpha3'

gem 'jquery-rails'

gem "sassc-rails"

gem 'popper_js', '~> 2.11', '>= 2.11.7'

ruby "3.2.2"

gem 'rails-i18n'

gem 'turbo-rails', '~> 1.4'

# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.9', '>= 4.9.2'

# Fichier de traduction de Devise
gem 'devise-i18n', '~> 1.11'

# A simple Rails calendar
gem "simple_calendar", "~> 2.4"

# Agnostic pagination in plain ruby.
gem 'pagy', '~> 6.0', '>= 6.0.4'

# Clean ruby syntax for writing and deploying cron jobs.
gem 'whenever', '~> 1.0'

# Create beautiful JavaScript charts with one line of Ruby
gem 'chartkick', '~> 5.0', '>= 5.0.2'

# The simplest way to group temporal data
gem 'groupdate', '~> 6.2', '>= 6.2.1'

# Loads environment variables from `.env`.
gem 'dotenv', '~> 2.8', '>= 2.8.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0', '>= 7.0.5'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "capistrano"
  gem "capistrano-rails"
  gem 'capistrano-rbenv'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
