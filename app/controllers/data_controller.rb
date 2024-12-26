class DataController < ApplicationController
  before_action :require_role, only: [:index, :update_amount, :paid]
  
  def index
    @past_events = Event.where('DATE(end_time) < ?', Date.today)
                       .where.not(user_id: nil)
                       .includes(:user, :doctor, :site)
                       .order('start_time DESC')
    
    @upcoming_events = Event.where('DATE(start_time) >= ?', Date.today)
                          .where.not(user_id: nil)
                          .includes(:user, :doctor, :site)
                          .order('start_time ASC')
    
    if params[:year].present? || params[:month].present? || params[:site].present?
      @past_events = EventQueries.past_events(filter_params)
      @upcoming_events = EventQueries.upcoming_events(filter_params)
    end
    
    @past_pagy, @past_events = pagy(@past_events)
    @upcoming_pagy, @upcoming_events = pagy(@upcoming_events)

    respond_to do |format|
      format.html
      format.csv { send_data CsvExportService.events_to_csv(@past_events), filename: csv_filename }
    end
  end

  def paid
    @event = Event.find(params[:id])
    
    if @event.update(event_params)
      redirect_to datas_path, notice: "Statut de paiement mis à jour avec succès."
    else
      redirect_to datas_path, alert: "Erreur lors de la mise à jour du statut de paiement."
    end
  end

  def userdata
    @past_events = Event.where('DATE(end_time) < ?', Date.today)
                       .where(user_id: current_user.id)
                       .includes(:user, :doctor, :site)
                       .order('start_time DESC')
    
    @upcoming_events = Event.where('DATE(start_time) >= ?', Date.today)
                          .where(user_id: current_user.id)
                          .includes(:user, :doctor, :site)
                          .order('start_time ASC')
    
    if params[:year].present? || params[:month].present? || params[:site].present?
      @past_events = EventQueries.past_events(filter_params).where(user_id: current_user.id)
      @upcoming_events = EventQueries.upcoming_events(filter_params).where(user_id: current_user.id)
    end
    
    @past_pagy, @past_events = pagy(@past_events)
    @upcoming_pagy, @upcoming_events = pagy(@upcoming_events)

    respond_to do |format|
      format.html
      format.csv { send_data CsvExportService.events_to_csv(@past_events), filename: csv_filename }
    end
  end

  def update_amount
    @event = Event.find(params[:id])
    amount = params[:amount]&.to_f
    reversion = @event.reversion
    amount_paid = calculate_amount_paid(amount, reversion)

    if @event.update(amount: amount, amount_paid: amount_paid)
      flash[:notice] = "Montant du remplacement et Montant à reverser mis à jour avec succès."
    else
      flash[:error] = "Erreur lors de la mise à jour du Montant du remplacement."
    end

    redirect_to datas_path
  end

  def generate_contract
    @event = Event.find(params[:id])
    
    if @event.user.present?
      contract_service = ContractGenerationService.new(@event)
      if contract_service.generate_and_attach
        flash[:success] = "Le contrat a été généré avec succès."
      else
        flash[:error] = "Erreur lors de la génération du contrat."
      end
    else
      flash[:warning] = "Impossible de générer un contrat sans remplaçant."
    end
    
    redirect_to datas_path
  end

  private

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non Autorisé."
    end
  end

  def event_params
    params.require(:event).permit(
      :payment_status, :payment_method, :payment_date, :payment_details
    )
  end

  def filter_params
    {
      year: params[:year],
      month: params[:month],
      site: params[:site]
    }
  end

  def calculate_amount_paid(amount, reversion)
    return 0 unless amount && reversion
    amount * reversion / 100
  end

  def csv_filename
    "Remplacements-#{params[:month]}-#{params[:year]}.csv"
  end
end