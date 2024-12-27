class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    @mailing_lists = MailingList.all
    super
  end

  def create
    @mailing_lists = MailingList.all
    super
  end

  def edit
    @mailing_lists = MailingList.all
    super
  end

  def update
    @mailing_lists = MailingList.all
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # Supprime les paramètres de mot de passe s'ils sont vides
    if account_update_params[:password].blank?
      account_update_params.delete(:password)
      account_update_params.delete(:password_confirmation)
    end

    if update_resource(resource, account_update_params)
      bypass_sign_in resource, scope: resource_name
      if resource.status == "En attente"
        redirect_to pending_path, notice: 'Profil mis à jour avec succès. Un administrateur va valider votre inscription.'
      else
        redirect_to root_path, notice: 'Profil mis à jour avec succès.'
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :edit
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :title, :phone, :address, :postal_code, :city, :siret_number, :license_number, :date_of_birth, :signature, mailing_list_ids: []])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :title, :phone, :address, :postal_code, :city, :siret_number, :license_number, :date_of_birth, :signature, mailing_list_ids: []])
  end

  def after_sign_up_path_for(resource)
    pending_path
  end

  def after_update_path_for(resource)
    if resource.status == "En attente"
      pending_path
    else
      root_path
    end
  end

  def update_resource(resource, params)
    # Supprime les paramètres de mot de passe s'ils sont vides
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      resource.assign_attributes(params)
      resource.save(validate: true)
    else
      resource.assign_attributes(params)
      resource.save(validate: true)
    end
  end
end
