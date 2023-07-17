class DataController < ApplicationController
  before_action :require_role, only: [:index, :update_amount, :generate_contract]


  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non Autorisé."
    end
  end

  def index
    @contracts = Event.where.not(contract_blob: nil)
    @past_events = Event.where.not(user_id: nil).where('end_time < ?', Time.now)
    @upcoming_events = Event.where.not(user_id: nil).where('start_time > ?', Time.now)
    @past_pagy, @past_events = pagy(@past_events) if @past_events.present?
    @upcoming_pagy, @upcoming_events = pagy(@upcoming_events) if @upcoming_events.present?
  end

  def userdata
    @past_events = Event.where(user_id: current_user.id).where('end_time < ?', Time.now)
    @upcoming_events = Event.where(user_id: current_user.id).where('start_time > ?', Time.now)
  
    if @past_events.present?
      @past_pagy, @past_events = pagy(@past_events)
    end
  
    if @upcoming_events.present?
      @upcoming_pagy, @upcoming_events = pagy(@upcoming_events)
    end
  end

  def update_amount
  @event = Event.find(params[:id])
  amount = params[:amount]&.to_f if params[:amount].present?
  reversion = @event.reversion

  if reversion.present?
    amount_paid = amount * reversion / 100
  else
    amount_paid = 0
  end

  if @event.update(amount: amount, amount_paid: amount_paid)
    flash[:notice] = "Montant du Remplacement et Montant à Payer mis à jour avec succès."
  else
    flash[:error] = "Erreur lors de la mise à jour du Montant du remplacement."
  end

  redirect_to datas_path
end

def cancel_booking
  @event = Event.find(params[:id])
  max_replacement_cancel = AppSetting.first.max_replacement_cancel.to_i

  if @event.start_time > (Date.today + max_replacement_cancel.days)
    @event.update(user_id: nil)
    flash[:notice] = "Remplacement Annulé avec Succès."
  else
    flash[:alert] = "Impossible d'Annuler ce Remplacement car le délai est inférieur à #{max_replacement_cancel} jours, contacter directement le cabinet !"
  end

  redirect_to userdata_path
end


  def generate_contract
    @user = User.find(params[:user_id])
    @site = Site.find(params[:site_id])
    @doctor = Doctor.find(params[:doctor_id])
    @event = Event.find(params[:id])

    # Chargement du modèle de contrat depuis le dossier public
    contract_template = File.read(Rails.root.join('public', 'contrat.html'))
    
    # Remplacement de chaque balise par sa correspondance en utilisant les informations récupérées ci-dessus
    contract = contract_template.gsub('user.title', @user.try(:title).to_s)
                                .gsub('user.last_name', @user.try(:last_name).to_s)
                                .gsub('user.first_name', @user.try(:first_name).to_s)
                                .gsub('user.email', @user.try(:email).to_s)
                                .gsub('user.phone', @user.try(:phone).to_s)
                                .gsub('user.address', @user.try(:address).to_s)
                                .gsub('user.postal_code', @user.try(:postal_code).to_s)
                                .gsub('user.city', @user.try(:city).to_s)
                                .gsub('user.siret_number', @user.try(:siret_number).to_s)
                                .gsub('user.license_number', @user.try(:license_number).to_s)
                                .gsub('doctor.title', @doctor.try(:title).to_s)
                                .gsub('doctor.first_name', @doctor.try(:first_name).to_s)
                                .gsub('doctor.last_name', @doctor.try(:last_name).to_s)
                                .gsub('doctor.rpps', @doctor.try(:rpps).to_s)
                                .gsub('doctor.email', @doctor.try(:email).to_s)
                                .gsub('doctor.phone', @doctor.try(:phone).to_s)
                                .gsub('site.name', @site.try(:name).to_s)
                                .gsub('site.address', @site.try(:address).to_s)
                                .gsub('site.postal_code', @site.try(:postal_code).to_s)
                                .gsub('site.city', @site.try(:city).to_s)
                                .gsub('event.start_date', @event.try(:start_time).try(:strftime, "%d/%m/%Y").to_s)
                                .gsub('event.end_date', @event.try(:end_time).try(:strftime, "%d/%m/%Y").to_s)
                                .gsub('event.start_time', @event.try(:start_time).try(:strftime, "%H:%M").to_s)
                                .gsub('event.end_time', @event.try(:end_time).try(:strftime, "%H:%M").to_s)
                                .gsub('event.reversion', @event.try(:reversion).to_s)
    
    if @doctor.signature.attached?
      contract_with_doctor_image = contract.gsub('doctor.signature', url_for(@doctor.signature))
    else
      contract_with_doctor_image = contract.gsub('doctor.signature', 'Aucune signature disponible')
    end
    
    if @user.signature.attached?
      contract_with_user_image = contract_with_doctor_image.gsub('user.signature', url_for(@user.signature))
    else
      contract_with_user_image = contract_with_doctor_image.gsub('user.signature', 'Aucune signature disponible')
    end
    
     # Create a temporary file with the contract content
  temp_file = Tempfile.new(['generated_contrat', '.txt'])
  temp_file.write(contract_with_user_image)
  temp_file.rewind

  # Attach the temporary file as a blob to the event
  @event.contract_blob.attach(io: temp_file, filename: 'contract.txt')

  # Close and delete the temporary file
  temp_file.close
  temp_file.unlink

  @event.update(contract_generated: true)

  redirect_to datas_path, notice: "Le fichier de contrat a été créé avec succès."
end

def download_contract
  event = Event.find(params[:id])
  contract_blob = event.contract_blob

  if contract_blob.attached?
    contract_content = contract_blob.download
    render html: contract_content.html_safe
  else
    redirect_to datas_path, alert: "Le fichier de contrat n'est pas disponible."
  end
end

def validate_contract
  @event = Event.find(params[:id])

  if @event.update(contract_validated: true)
    flash[:notice] = "Contrat validé !"
  else
    flash[:alert] = "Impossible de valider le contrat !"
  end

  redirect_to userdata_path
end


end