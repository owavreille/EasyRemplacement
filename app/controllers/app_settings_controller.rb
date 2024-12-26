class AppSettingsController < ApplicationController
  def index
    @app_settings = AppSetting.find(1)
  end

  def update
    @app_settings = AppSetting.find(1)
    if @app_settings.update(app_settings_params)
      flash[:success] = 'Les paramètres ont été mis à jour avec succès !'
      redirect_to app_settings_path
    else
      flash.now[:error] = 'Erreur lors de la mise à jour des paramètres.'
      render :index
    end
  end  

  def delete_logo
    @app_settings = AppSetting.find(params[:id])
    if @app_settings.logo.attached?
      @app_settings.logo.purge
      flash[:success] = 'Le logo a été supprimé avec succès !'
    else
      flash[:warning] = 'Aucun logo à supprimer.'
    end
    redirect_to app_settings_path
  end
  
  private

  def app_settings_params
    params.require(:app_setting).permit(:app_name, :disable_booking_threshold, :am_pm_hour_separation, :minimal_replacement_length, :max_replacement_cancel, :logo)
  end
end
