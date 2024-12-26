class UsersController < ApplicationController
  before_action :require_admin, except: [:show, :edit, :update, :delete_signature_profile, :pending]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :active, :inactive, :delete_signature, :delete_signature_profile]
  before_action :ensure_user_authorized, only: [:edit, :update, :delete_signature_profile]
  before_action :prevent_admin_self_modification, only: [:update, :destroy, :inactive]

  def index
    @pagy, @users = pagy(
      params[:search].present? ? User.search_by_name(params[:search]) : User.all,
      items: 10
    )
  end

  def show
    redirect_to root_path, alert: "Accès non autorisé." unless can_view_user?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to @user, notice: 'Utilisateur créé avec succès.'
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @mailing_lists = MailingList.all
  end
  
  def update
    @mailing_lists = MailingList.all
  
    if @user.update(user_params)
      redirect_to current_user.role? ? users_path : root_path, 
                  notice: 'Profil mis à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def active
    update_user_status(true, "L'utilisateur a été activé.")
  end

  def inactive
    update_user_status(false, "L'utilisateur a été désactivé.")
  end

  def delete_signature
    delete_user_signature(edit_user_path(@user))
  end

  def delete_signature_profile
    delete_user_signature(edit_user_registration_path)
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'Utilisateur supprimé avec succès.'
  end

  def toggle_active
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to users_path, alert: "Vous ne pouvez pas modifier votre propre statut."
    elsif @user.role?
      redirect_to users_path, alert: "Vous ne pouvez pas modifier le statut d'un administrateur."
    else
      @user.update(active: !@user.active?)
      redirect_to users_path, notice: "Le statut de l'utilisateur a été mis à jour."
    end
  end

  def pending
    # Cette action est accessible à tous les utilisateurs
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "Utilisateur non trouvé"
  end

  def user_params
    permitted_params = [:title, :first_name, :last_name, :date_of_birth, 
                       :email, :phone, :username, :password, :password_confirmation,
                       :address, :postal_code, :city, :license_number, 
                       :siret_number, :mailing_list_id, :signature, 
                       :speciality, :rib, { site_ids: [] }]
    
    # Seuls les admins peuvent modifier ces champs
    permitted_params += [:role, :active] if current_user&.role?
    
    params.require(:user).permit(permitted_params)
  end

  def ensure_user_authorized
    unless can_edit_user?
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def can_edit_user?
    current_user&.role? || current_user == @user
  end

  def can_view_user?
    current_user&.role? || current_user == @user
  end

  def update_user_status(status, message)
    if @user&.update(active: status)
      redirect_to users_path, notice: message
    else
      redirect_to users_path, alert: "Une erreur est survenue."
    end
  end

  def delete_user_signature(redirect_path)
    if @user.signature.attached?
      @user.signature.purge
      redirect_to redirect_path, notice: "La signature a été supprimée avec succès."
    else
      redirect_to redirect_path, alert: "Aucune signature à supprimer."
    end
  end

  def prevent_admin_self_modification
    if @user.role? && @user == current_user
      redirect_to users_path, alert: "Vous ne pouvez pas modifier ou désactiver votre propre compte administrateur."
      return
    end
  end
end