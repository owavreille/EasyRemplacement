require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module EasyRemplacement
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr
    config.settings = config_for(:settings)
  end
end
