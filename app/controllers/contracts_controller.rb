class ContractsController < ApplicationController
  before_action :require_admin, except: [:view_contract, :open_contract, :validate_contract]
  before_action :set_event, only: [:validate_contract]
  before_action :authorize_contract_validation, only: [:validate_contract]

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

  def generate_contract
    @event = Event.find(params[:id])
    
    if ContractService.generate_contract(@event)
      redirect_to datas_path, notice: "Le fichier de contrat a été créé avec succès."
    else
      redirect_to datas_path, alert: "Impossible de générer le contrat."
    end
  end

  def view_contract
    event = Event.find(params[:id])
    
    if event.contract_blob.attached?
      contract_content = event.contract_blob.download
      sanitized_content = ActionController::Base.helpers.sanitize(contract_content)
      render html: sanitized_content.html_safe, layout: true, locals: { readonly: true }
    else
      redirect_to userdata_path, alert: "Le fichier de contrat n'est pas disponible."
    end
  end

  def open_contract
    @event = Event.find(params[:id])
    
    if @event.contract_blob.attached?
      @contract_content = @event.contract_blob.download.force_encoding('UTF-8')
      render 'index'
    else
      redirect_to datas_path, alert: "Le fichier de contrat n'est pas disponible."
    end
  end

  def validate_contract
    @event = Event.find(params[:id])
   
    if !@event.user.signature.attached?
      redirect_to userdata_path, 
                alert: "Vous devez d'abord ajouter votre signature dans votre profil avant de pouvoir signer le contrat."
      return
    end

    if @event.contract_blob.attached?
      @event.update!(contract_validated: true)
      
      # Envoyer le mail seulement si le CDOM a un email configuré
      if @event.site&.cdom&.email.present?
        NotificationMailer.contract_validated(@event).deliver_later
      end
      
      redirect_to userdata_path, 
                  notice: "Contrat validé avec succès !"
    else
      redirect_to userdata_path, 
                  alert: "Impossible de valider le contrat !"
    end
  rescue StandardError => e
    Rails.logger.error "Erreur lors de la validation du contrat: #{e.message}"
    redirect_to userdata_path, 
                alert: "Une erreur est survenue lors de la validation du contrat."
  end

  private

  def require_admin
    unless current_user&.role?
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_contract_validation
    unless @event.user_id == current_user.id
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
end