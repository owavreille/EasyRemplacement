
require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module EasyRemplacement
  class Application < Rails::Application
    config.load_defaults 8.0
    
    # Add presenters to autoload paths
    config.autoload_paths += %W(#{config.root}/app/presenters)
    
    # Localization
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr, :en]
    
    # Time zone - CRITICAL for Groupdate
    config.time_zone = 'Paris'
    config.active_record.default_timezone = :utc

    # Active Job
    config.active_job.queue_adapter = :async

    # Active Storage
    config.active_storage.variant_processor = :vips

    # Security
    config.action_controller.default_protect_from_forgery = true
    config.ssl_options = { hsts: { subdomains: true } }

    # Performance
    config.cache_store = :memory_store
    config.action_controller.perform_caching = true

    # Logging
    config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')
    config.log_tags = [:request_id]

    # Autoloading
    config.autoload_lib(ignore: %w(assets tasks))
  end
end