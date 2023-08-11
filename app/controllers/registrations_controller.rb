class RegistrationsController < Devise::RegistrationsController

  def create
    @user = User.new(sign_up_params) # Utiliser sign_up_params à la place de user_params
    if @user.save
      admin_users = User.where(role: true)
      admin_users.each do |admin_user|
        UserMailer.new_user_notification(admin_user).deliver_now
      end
      sign_in @user
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  private
  
    def sign_up_params
      params.require(:user).permit(:title, :last_name, :first_name, :date_of_birth, :phone, :email, :address, :postal_code, :city, :siret_number, :license_number, :password, :password_confirmation, :mailing_list_id, :rib, :speciality, :signature)
    end
  
    def account_update_params
      params.require(:user).permit(:title, :last_name, :first_name, :date_of_birth, :phone, :email, :address, :postal_code, :city, :siret_number, :license_number, :password, :password_confirmation, :current_password, :mailing_list_id, :rib, :speciality, :signature, site_ids: [])
    end
end
