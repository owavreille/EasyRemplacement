class SettingsService
  def self.update_settings(settings, params)
    settings.transaction do
      update_app_settings(settings, params)
      handle_logo_upload(settings, params[:logo]) if params[:logo]
      settings
    end
  end

  def self.remove_logo(settings)
    settings.logo.purge if settings.logo.attached?
  end

  private

  def self.update_app_settings(settings, params)
    settings.update!(
      app_name: params[:app_name],
      disable_booking_threshold: params[:disable_booking_threshold],
      max_replacement_cancel: params[:max_replacement_cancel],
      am_pm_hour_separation: params[:am_pm_hour_separation],
      minimal_replacement_length: params[:minimal_replacement_length]
    )
  end

  def self.handle_logo_upload(settings, logo)
    settings.logo.purge if settings.logo.attached?
    settings.logo.attach(logo)
  end
end