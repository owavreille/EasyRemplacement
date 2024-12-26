class ApplicationController < ActionController::Base
  include Pagy::Backend
  include AuthenticationConcern
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_app_settings
  before_action :load_notifications
  before_action :check_user_active, if: :user_signed_in?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :title, :last_name, :first_name, :date_of_birth, 
      :phone, :address, :postal_code, :city, 
      :siret_number, :license_number, :rib, 
      :speciality, :signature
    ])
    
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :title, :last_name, :first_name, :date_of_birth, 
      :phone, :address, :postal_code, :city, 
      :siret_number, :license_number, :rib, 
      :speciality, :signature, :current_password,
      { site_ids: [], mailing_list_ids: [] }
    ])
  end

  def check_user_active
    unless current_user.active? || pending_page? || devise_page? || edit_registration_page?
      redirect_to pending_path, alert: "Votre compte n'est pas encore activé."
    end
  end

  private

  def edit_registration_page?
    devise_controller? && controller_name == 'registrations' && action_name == 'edit'
  end

  def pending_page?
    controller_name == 'users' && action_name == 'pending'
  end

  def devise_page?
    devise_controller? && (action_name == 'sign_out' || action_name == 'destroy')
  end

  def user_params
    [
      :title, :role, :last_name, :first_name, :date_of_birth,
      :phone, :address, :postal_code, :city, :signature,
      :siret_number, :license_number, :mailing_list_id,
      :active, :email, :password, :speciality, :rib,
      { favorite_site_ids: [], mailing_list_ids: [] }
    ]
  end

  def set_app_settings
    @app_settings = AppSetting.first
    @app_name = @app_settings&.app_name || "EasyRemplacement"
  end

  def load_notifications
    return unless current_user
    
    @upcoming_events_with_contract = Event.upcoming_with_contract(current_user).count
    @contract_to_generate = Event.pending_contracts.count if current_user.role?
    @events_to_plan = Event.to_be_planned.count
  end
end