class DataController < ApplicationController
  before_action :require_role, only: [:index, :update_amount, :generate_contract]
  require 'csv'


  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non Autorisé."
    end
  end
  def index
    @events = Event.all
    params[:year] ||= Date.current.year.to_s
  
    # Filtrage par année et mois
    if params[:year].present? && params[:month].present?
      @events = @events.where('start_time >= ? AND end_time <= ?', Date.new(params[:year].to_i, params[:month].to_i).beginning_of_month, Date.new(params[:year].to_i, params[:month].to_i).end_of_month)
    elsif params[:year].present?
      @events = @events.where('start_time >= ? AND end_time <= ?', Date.new(params[:year].to_i).beginning_of_year, Date.new(params[:year].to_i).end_of_year)
    end
  
    # Filtrage par site
    @events = @events.where(site_id: params[:site]) if params[:site].present?
  
    @contracts = @events.where.not(contract_blob: nil)
    @past_events = @events.where.not(user_id: nil).where('end_time < ?', Time.now)
    @upcoming_events = @events.where.not(user_id: nil).where('start_time > ?', Time.now)
  
    @past_pagy, @past_events = pagy(@past_events) if @past_events.present?
    @upcoming_pagy, @upcoming_events = pagy(@upcoming_events) if @upcoming_events.present?
  
    respond_to do |format|
      format.html
      format.csv { send_data events_to_csv(@past_events), filename: "Remplacements-#{params[:month]}-#{params[:year]}.csv" }
    end
  end
  

  def userdata
    params[:year] ||= Date.current.year.to_s
  
    @events = Event.all
  
    # Filtrage par année et mois
    if params[:month].present?
      @events = @events.where('start_time >= ? AND end_time <= ?', Date.new(params[:year].to_i, params[:month].to_i).beginning_of_month, Date.new(params[:year].to_i, params[:month].to_i).end_of_month)
    else
      @events = @events.where('start_time >= ? AND end_time <= ?', Date.new(params[:year].to_i).beginning_of_year, Date.new(params[:year].to_i).end_of_year)
    end
  
    # Filtrage par site
    @events = @events.where(site_id: params[:site]) if params[:site].present?
  
    # Filtrage par user_id
    @events = @events.where(user_id: current_user.id)
  
    @past_events = @events.where('end_time < ?', Time.now)
    @upcoming_events = @events.where('start_time > ?', Time.now)
  
    @past_pagy, @past_events = pagy(@past_events) if @past_events.present?
    @upcoming_pagy, @upcoming_events = pagy(@upcoming_events) if @upcoming_events.present?
  
    respond_to do |format|
      format.html
      format.csv { send_data userdata_csv(@past_events), filename: "Remplacements-#{params[:month]}-#{params[:year]}.csv" }
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
    flash[:notice] = "Montant du remplacement et Montant à reverser mis à jour avec succès."
  else
    flash[:error] = "Erreur lors de la mise à jour du Montant du remplacement."
  end

  redirect_to datas_path
end

def events_to_csv(events)
  CSV.generate(headers: true) do |csv|
    csv << ["Site", "Date", "Médecin Remplacé", "Début", "Fin", "Nb de Patients", "Aide de Cs", "Remplaçant", "Montant", "Montant Reversé", "Taux Reversion", "Date Paiement", "Méthode de Paiement", "Détails Paiement"]
    events.each do |event|
      csv << [
        event.site.name,
        event.start_time.strftime("%d/%m/%Y"),
        "Dr #{event.doctor.first_name} #{event.doctor.last_name}",
        event.start_time.strftime("%H:%M"),
        event.end_time.strftime("%H:%M"),
        event.number_of_patients,
        event.helper ? 'oui' : 'non',
        "#{event.user.first_name} #{event.user.last_name}",
        event.amount,
        event.amount_paid,
        "#{event.reversion} %",
        event.payment_date,
        event.payment_method,
        event.payment_details
      ]
    end
  end
end

def userdata_csv(events)
  CSV.generate(headers: true) do |csv|
    csv << ["Site", "Date", "Médecin Remplacé", "Début", "Fin", "Nb de Patients", "Aide de Cs", "Montant Reversé", "Taux Reversion"]
    events.each do |event|
      csv << [
        event.site.name,
        event.start_time.strftime("%d/%m/%Y"),
        "Dr #{event.doctor.first_name} #{event.doctor.last_name}",
        event.start_time.strftime("%H:%M"),
        event.end_time.strftime("%H:%M"),
        event.number_of_patients,
        event.helper ? 'oui' : 'non',
        event.amount_paid,
        "#{event.reversion} %"
      ]
    end
  end
end


end