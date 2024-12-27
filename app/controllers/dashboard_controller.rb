class DashboardController < ApplicationController
  before_action :require_admin
  rescue_from StandardError, with: :handle_error

  def index
    begin
      load_event_stats
      load_user_stats
      load_entity_stats
      load_contract_stats
      load_financial_stats
    rescue StandardError => e
      Rails.logger.error "Erreur dans le dashboard: #{e.message}\n#{e.backtrace.join("\n")}"
      flash.now[:alert] = "Une erreur est survenue lors du chargement des statistiques."
      render :error
    end
  end

  private

  def require_admin
    unless current_user&.role?
      flash[:error] = "Accès non autorisé"
      redirect_to root_path
    end
  end

  def load_event_stats
    @total_events = Event.count
    @upcoming_events = Event.where('start_time > ?', Time.current).count
    @past_events = Event.where('end_time < ?', Time.current).count
    @unbooked_events = Event.where(user_id: nil).count
  end

  def load_user_stats
    @total_users = User.count
    @active_users = User.where(active: true).count
    @pending_users = User.where(active: false).count
    @admin_users = User.where(role: true).count
  end

  def load_entity_stats
    @total_sites = Site.count
    @total_doctors = Doctor.count
  end

  def load_contract_stats
    @contracts_generated = Event.joins(:contract_blob_attachment).count
    @contracts_validated = Event.where(contract_validated: true).count
    @contracts_pending = @contracts_generated - @contracts_validated
  end

  def load_financial_stats
    @site_stats = Site.left_joins(:events)
                     .where('events.start_time >= ? OR events.start_time IS NULL', 5.years.ago)
                     .group('sites.id', 'sites.name')
                     .select('sites.name, 
                             COUNT(events.id) as event_count,
                             COALESCE(SUM(CASE WHEN events.amount IS NOT NULL THEN events.amount ELSE 0 END), 0) as total_amount,
                             COALESCE(AVG(NULLIF(events.amount, 0)), 0) as avg_amount')
                     .order('total_amount DESC')

    events_with_amount = Event.where('start_time >= ?', 5.years.ago)
                             .where.not(amount: [nil, 0])

    @total_amount = events_with_amount.sum(:amount).to_f
    @avg_amount_per_event = calculate_average_amount(events_with_amount)
  end

  def calculate_average_amount(events)
    return 0 if events.count.zero?
    (events.sum(:amount).to_f / events.count).round(2)
  end

  def handle_error(exception)
    Rails.logger.error "Erreur dans le dashboard: #{exception.message}\n#{exception.backtrace.join("\n")}"
    flash[:error] = "Une erreur est survenue lors du chargement du dashboard."
    redirect_to root_path
  end
end 