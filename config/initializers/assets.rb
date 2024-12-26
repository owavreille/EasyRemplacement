# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# Explicitly add SCSS files to precompile
Rails.application.config.assets.precompile += %w( *.scss )

# Add SCSS to asset paths
Rails.application.config.sass.preferred_syntax = :scss
Rails.application.config.sass.load_paths << Rails.root.join('app', 'assets', 'stylesheets')

# Ensure Google sign-in button images are precompiled
Rails.application.config.assets.precompile += %w(
  btn_google_signin_light_normal_web.png
  btn_google_signin_light_disabled_web.png
  btn_google_signin_light_focus_web.png
  btn_google_signin_light_pressed_web.png
  btn_google_signin_dark_normal_web.png
  btn_google_signin_dark_disabled_web.png
  btn_google_signin_dark_focus_web.png
  btn_google_signin_dark_pressed_web.png
)
