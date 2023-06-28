class RegistrationsController < Devise::RegistrationsController
    private
  
    def sign_up_params
      params.require(:user).permit(:title, :last_name, :first_name, :date_of_birth, :phone, :email, :address, :postal_code, :city, :siret_number, :license_number, :password, :password_confirmation, :mailing_list_id, :rib, :speciality)
    end
  
    def account_update_params
      params.require(:user).permit(:title, :last_name, :first_name, :date_of_birth, :phone, :email, :address, :postal_code, :city, :siret_number, :license_number, :password, :password_confirmation, :current_password, :mailing_list_id, :rib, :speciality)
    end
  end
  