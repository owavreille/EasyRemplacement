class RegistrationsController < Devise::RegistrationsController

  def create
    @user = User.new(sign_up_params)
    if @user.save
      admin_users = User.where(role: true)
      admin_users.each do |admin_user|
        UserMailer.new_user_notification(admin_user, @user).deliver_later
      end
      sign_in @user
      redirect_to pending_path, 
                  notice: 'Votre compte a été créé avec succès. Un administrateur va valider votre inscription.'
    else
      flash.now[:alert] = 'Il y a des erreurs dans le formulaire.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = resource
    @mailing_lists = MailingList.all
  end
  
  def update
    @user = resource
    @mailing_lists = MailingList.all
  
    if @user.update(account_update_params)
      redirect_to pending_path, 
                  notice: 'Profil mis à jour avec succès. Un administrateur va valider votre inscription.'
    else
      flash.now[:alert] = 'Il y a des erreurs dans le formulaire.'
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
    def sign_up_params
      params.require(:user).permit(
        :title, :last_name, :first_name, :date_of_birth, 
        :email, :password, :password_confirmation
      )
    end
  
    def account_update_params
      params.require(:user).permit(
        :title, :last_name, :first_name, :date_of_birth, 
        :phone, :email, :address, :postal_code, :city, 
        :siret_number, :license_number, :rib, :speciality, 
        :signature, :current_password, site_ids: [], mailing_list_ids: []
      )
    end
end
