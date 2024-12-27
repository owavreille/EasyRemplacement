class DashboardController < ApplicationController
  before_action :require_admin

  def index
    @total_events = Event.count
    @upcoming_events = Event.where('start_time > ?', Time.current).count
    @past_events = Event.where('end_time < ?', Time.current).count
    @unbooked_events = Event.where(user_id: nil).count

    @total_users = User.count
    @active_users = User.where(active: true).count
    @pending_users = User.where(active: false).count
    @admin_users = User.where(role: true).count

    @total_sites = Site.count
    @total_doctors = Doctor.count

    @contracts_generated = Event.joins(:contract_blob_attachment).count
    @contracts_validated = Event.where(contract_validated: true).count
    @contracts_pending = @contracts_generated - @contracts_validated

    @site_stats = Site.left_joins(:events)
                     .where('events.start_time >= ? OR events.start_time IS NULL', 5.years.ago)
                     .group('sites.id', 'sites.name')
                     .select('sites.name, 
                             COUNT(events.id) as event_count,
                             COALESCE(SUM(events.amount), 0) as total_amount,
                             COALESCE(AVG(events.amount), 0) as avg_amount')
                     .order('total_amount DESC')

    @total_amount = Event.where('start_time >= ?', 5.years.ago)
                        .where.not(amount: nil)
                        .sum(:amount) || 0
    @avg_amount_per_event = Event.where('start_time >= ?', 5.years.ago)
                                .where.not(amount: nil)
                                .average(:amount) || 0
  end

  private

  def require_admin
    unless current_user&.role?
      flash[:error] = "Accès non autorisé"
      redirect_to root_path
    end
  end
end 