class RegistrationsController < Devise::RegistrationsController

  def create
    @user = User.new(sign_up_params)
    if @user.save
      admin_users = User.where(role: true)
      admin_users.each do |admin_user|
        UserMailer.new_user_notification(admin_user, @user).deliver_later
      end
      sign_in @user
      redirect_to root_path
    else
      render 'new'
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
      redirect_to users_path, notice: 'Profil mis à jour avec succès.'
    else
      render :edit, notice: 'Echec de la mise à jour !'
    end
  end
  
  private
  
    def sign_up_params
      params.require(:user).permit(:title, :last_name, :first_name, :date_of_birth, :phone, :email, :address, :postal_code, :city, :siret_number, :license_number, :password, :password_confirmation, :rib, :speciality, :signature)
    end
  
    def account_update_params
      params.require(:user).permit(:title, :last_name, :first_name, :date_of_birth, :phone, :email, :address, :postal_code, :city, :siret_number, :license_number, :password, :password_confirmation, :rib, :speciality, :signature, site_ids: [], mailing_list_ids: [])
    end
end
