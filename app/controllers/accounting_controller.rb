class AccountingController < ApplicationController
  before_action :require_role
  before_action :set_default_year, only: [:amounts, :amounts_by_site, :amounts_by_doctor, :amounts_by_user]

  def amounts
    totals = AccountingService.calculate_totals(filtered_events, group_by: group_method)
    @amount = totals[:amount]
    @amount_paid = totals[:amount_paid]
    @amount_earned = totals[:amount_earned]
    
    respond_to do |format|
      format.html
      format.csv { send_data CsvExportService.amounts_to_csv(totals), filename: csv_filename }
    end
  end

  def amounts_by_site
    totals = AccountingService.calculate_totals_by_entity(filtered_events, :site)
    @amount = totals[:amount]
    @amount_paid = totals[:amount_paid]
    @amount_earned = totals[:amount_earned]
    
    respond_to do |format|
      format.html
      format.csv { send_data CsvExportService.amounts_by_site_to_csv(totals), filename: csv_filename }
    end
  end

  def amounts_by_doctor
    totals = AccountingService.calculate_totals_by_entity(filtered_events, :doctor)
    @amount = totals[:amount]
    @amount_paid = totals[:amount_paid]
    @amount_earned = totals[:amount_earned]
    
    respond_to do |format|
      format.html
      format.csv { send_data CsvExportService.amounts_by_doctor_to_csv(totals), filename: csv_filename }
    end
  end

  def amounts_by_user
    totals = AccountingService.calculate_totals_by_entity(filtered_events, :user)
    @amount = totals[:amount]
    @amount_paid = totals[:amount_paid]
    @amount_earned = totals[:amount_earned]
    
    respond_to do |format|
      format.html
      format.csv { send_data CsvExportService.amounts_by_user_to_csv(totals), filename: csv_filename }
    end
  end

  private

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def filtered_events
    events = Event.includes(:site, :doctor, :user)
    
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

  def group_method
    case params[:group_by]
    when "month" then :month
    when "year" then :year
    else :month
    end
  end

  def csv_filename
    "Remplacements-#{params[:month]}-#{params[:year]}.csv"
  end

  def set_default_year
    params[:year] ||= Date.current.year.to_s
  end
end