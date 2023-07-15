class AppSettingsController < ApplicationController
  def index
    @app_settings = AppSetting.all
  end

  def update
    @app_settings = AppSetting.all
    if @app_settings.update(app_settings_params)
      redirect_to app_settings_path, notice: 'Paramètres mis à jour avec succès !'
    else
      render :index
    end
  end

  private

  def app_settings_params
    params.require(:app_setting).permit(:app_name, :disable_booking_threshold, :am_pm_hour_separation, :minimal_replacement_length)
  end
end
