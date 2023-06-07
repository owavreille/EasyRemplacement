class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :active]


  def index
    @users = User.all
  end

  def show
    # Utilisez @user pour accéder aux données de l'utilisateur dans la vue
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'Utilisateur créé avec succès.'
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: 'Profil mis à jour avec succès.'
    else
      redirect_to edit_users_path, notice: 'Échec de la mise à jour !'
    end
  end
  
  def active
    if @user
      @user.update(active: true)
      redirect_to users_path, notice: "L'utilisateur a été activé."
    else
      redirect_to edit_users_path, notice: "L'utilisateur n'existe pas !"
    end
  end

  def delete_signature_profile
    @user = User.find(params[:id])
    @user.signature.purge # Supprime l'image attachée à la signature
    redirect_to edit_user_registration_path(@user), notice: "L'image de la signature a été supprimée avec succès."
  end

  def delete_signature
    @user = User.find(params[:id])
    @user.signature.purge # Supprime l'image attachée à la signature
    redirect_to edit_user_path(@user), notice: "L'image de la signature a été supprimée avec succès."
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'Utilisateur supprimé avec succès.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "Utilisateur non trouvé"
  end

  def user_params
    params.require(:user).permit(:title, :role, :first_name, :last_name, :date_of_birth, :email, :phone, :username, :password, :password_confirmation, :active, :address, :postal_code, :city, :license_number, :siret_number, :mailing_list_id, :signature_blob)
  end


end
