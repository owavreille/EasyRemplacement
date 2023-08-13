class ContractsController < ApplicationController
  
    def index
      @contract_path = Rails.public_path.join('contrat.html')
      @contract_content = File.read(@contract_path)
    end

  def generate_contract
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    @site = Site.find(@event.site_id)
    @doctor = Doctor.find(@event.doctor_id)

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

    def update_contract
      contract_content = params[:contract_content]
      contract_path = Rails.public_path.join('contrat.html')
      File.write(contract_path, contract_content)
      redirect_to contracts_path, notice: 'Le contrat a été mis à jour avec succès.'
    end

    def view_contract
      event = Event.find(params[:id])
      contract_blob = event.contract_blob
    
      if contract_blob.attached?
        contract_content = contract_blob.download
        render html: contract_content.html_safe
      else
        redirect_to userdata_path, alert: "Le fichier de contrat n'est pas disponible."
      end
    end
  
    def open_contract
      @event = Event.find(params[:id])
      contract_blob = @event.contract_blob
    
      if contract_blob.attached?
        contract_content = contract_blob.download
        @contract_content = contract_content.force_encoding('UTF-8')
        render 'index'
      else
        redirect_to datas_path, alert: "Le fichier de contrat n'est pas disponible."
      end
    end
    
    def save_contract
      @event = Event.find(params[:id])
    
      if @event.update(contract_content: params[:event][:contract_content])
        redirect_to @event, notice: "Contrat modifié avec succès."
      else
        render 'index', alert: "Erreur lors de la modification du contrat."
      end
    end
    
    def validate_contract
      @event = Event.find(params[:id])
    
      if @event.update(contract_validated: true)
        flash[:notice] = "Contrat validé et envoyé au Conseil de l'Ordre!"
    
        # Joindre le contrat en tant que pièce jointe à l'e-mail
        #contract_blob = @event.contract.blob
        #if @event.contract.attached?
        #  contract_content = contract_blob.download
        #  UserMailer.cdom_with_attachment(@event.site.cdom.email, @event, contract_content).deliver_now
        # else
        #   flash[:alert] = "Le fichier de contrat n'est pas disponible."
        # end
      else
        flash[:alert] = "Impossible de valider le contrat !"
      end
    
      redirect_to userdata_path
    end
    

  end