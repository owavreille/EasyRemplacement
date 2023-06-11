class ContractsController < ApplicationController
  before_action :require_role

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
  
    def index
      @contract_path = Rails.public_path.join('contrat.html')
      @contract_content = File.read(@contract_path)
    end
  
    def update_contract
      contract_content = params[:contract_content]
      contract_path = Rails.public_path.join('contrat.html')
      File.write(contract_path, contract_content)
      redirect_to contracts_path, notice: 'Le contrat a été mis à jour avec succès.'
    end
    
  end