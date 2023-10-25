class ApplicationController < ActionController::Base
include Pagy::Backend

    before_action :authenticate_user!
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :upcoming_events_with_contract
    before_action :contract_to_generate
    before_action :set_app_name
    before_action :set_app_settings
    before_action :events_to_plan

   def upcoming_events_with_contract
    if current_user
      @upcoming_events_with_contract = current_user.events.where(contract_generated: true, contract_validated: nil).where("start_time >= ?", Time.now).count
    else
      @upcoming_events_with_contract = 0
    end
  end

  def contract_to_generate
    count = Event.where(contract_generated: nil).where.not(user_id: nil).where("start_time >= ?", Date.today).count
    if count.present?
      @contract_to_generate = count
    else
      @contract_to_generate = 0
    end
  end

def events_to_plan
  if current_user
    @events_to_plan = Event.where(contract_validated: true).where(opened: nil).where("start_time >= ?", Date.today).count
  else
    @events_to_plan = 0
  end
end


     protected
          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:title, :role, :last_name, :first_name, :date_of_birth, :phone, :address, :postal_code, :city, :signature, :siret_number, :license_number, :mailing_list_id, :active, :email, :password)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:title, :role, :last_name, :first_name, :date_of_birth, :phone, :address, :postal_code, :city, :signature, :siret_number, :license_number, :mailing_list_id, :active, :email, :password, :current_password, favorite_site_ids: [])}
          end

     private

     def set_app_name
      app_setting = AppSetting.first
    
      if app_setting&.app_name.present?
        @app_name = app_setting.app_name
      else
        @app_name = "EasyRemplacement"
      end
    end    


  def set_app_settings
    @app_settings = AppSetting.first
  end


end
