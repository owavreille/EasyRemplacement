class OfficeController < ApplicationController
    before_action :require_active

    def require_active
      unless current_user&.active == true
        redirect_to root_path, alert: "Accès non autorisé."
      end
    end

    def index
        @doctors = Doctor.all
        @sites = Site.all
    end

end