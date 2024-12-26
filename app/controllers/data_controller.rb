class DataController < ApplicationController
  before_action :require_role, only: [:index, :update_amount]
  
  def index
    params[:year] ||= Date.current.year.to_s
    
    @events = filter_events
    @contracts = @events.where.not(contract_blob: nil)
    @past_events = EventQueries.past_events(filter_params)
    @upcoming_events = EventQueries.upcoming_events(filter_params)
    
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
      respond_to do |format|
        format.js
        format.html { redirect_to datas_path, notice: "Statut de paiement mis à jour avec succès." }
      end
    else
      respond_to do |format|
        format.js { render :paid, status: :unprocessable_entity }
        format.html { redirect_to datas_path, alert: "Erreur lors de la mise à jour du statut de paiement." }
      end
    end
  end

  def userdata
    params[:year] ||= Date.current.year.to_s
    
    @events = filter_events.where(user_id: current_user.id)
    @past_events = EventQueries.past_events(filter_params).where(user_id: current_user.id)
    @upcoming_events = EventQueries.upcoming_events(filter_params).where(user_id: current_user.id)
    
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

  def filter_events
    events = Event.all
    
    if params[:year].present? && params[:month].present?
      start_date = Date.new(params[:year].to_i, params[:month].to_i).beginning_of_month
      end_date = start_date.end_of_month
      events = events.where(start_time: start_date..end_date)
    elsif params[:year].present?
      start_date = Date.new(params[:year].to_i).beginning_of_year
      end_date = start_date.end_of_year
      events = events.where(start_time: start_date..end_date)
    end
    
    events = events.where(site_id: params[:site]) if params[:site].present?
    events
  end

  def calculate_amount_paid(amount, reversion)
    return 0 unless amount && reversion
    amount * reversion / 100
  end

  def csv_filename
    "Remplacements-#{params[:month]}-#{params[:year]}.csv"
  end
end