module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :check_user_active, if: :user_signed_in?
  end

  private

  def check_user_active
    unless current_user.active?
      redirect_to pending_path(current_user), 
                  alert: "Votre compte n'est pas encore activé."
    end
  end

  def require_admin
    unless current_user&.role?
      redirect_to root_path, 
                  alert: "Accès non autorisé."
    end
  end
end