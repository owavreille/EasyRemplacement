class ApplicationController < ActionController::Base
include Pagy::Backend

    before_action :authenticate_user!
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :upcoming_events_with_contract

   def upcoming_events_with_contract
    if current_user
      @upcoming_events_with_contract = current_user.events.where(contract_generated: true).where("start_time >= ?", Time.now).count
    else
      @upcoming_events_with_contract = 0
    end
  end

     protected
          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:title, :role, :last_name, :first_name, :date_of_birth, :phone, :address, :postal_code, :city, :signature, :siret_number, :license_number, :mailing_list, :active, :email, :password)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:title, :role, :last_name, :first_name, :date_of_birth, :phone, :address, :postal_code, :city, :signature, :siret_number, :license_number, :mailing_list, :active, :email, :password, :current_password)}
          end
end
