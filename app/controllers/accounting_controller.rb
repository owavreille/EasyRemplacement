class AccountingController < ApplicationController
  before_action :require_role

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def amounts
    @amount = group_and_sum(:amount)
    @amount_paid = group_and_sum(:amount_paid)
    @amount_earned = group_and_sum('amount - amount_paid')
  end

  def amounts_by_site
    @amount_by_site = group_and_sum_by_site(:amount)
    @amount_paid_by_site = group_and_sum_by_site(:amount_paid)
    @amount_earned_by_site = group_and_sum_by_site('amount - amount_paid')
  end
  
  def amounts_by_doctor
    @amount_by_doctor = group_and_sum_by(:doctor, :amount)
    @amount_paid_by_doctor = group_and_sum_by(:doctor, :amount_paid)
    @amount_earned_by_doctor = group_and_sum_by(:doctor, 'amount - amount_paid')
  end
  
def amounts_by_user
  @amount_by_user = group_and_sum_by(:user, :amount)
  @amount_paid_by_user = group_and_sum_by(:user, :amount_paid)
  @amount_earned_by_user = group_and_sum_by(:user, 'amount - amount_paid')
end

private
def determine_group_method
  case params[:group_by]
  when "month"
    :group_by_month
  when "year"
    :group_by_year
  else
    :group_by_month
  end
end

def group_and_sum(column_name)
  events_filtered_by_year = filter_events_by_month_and_year(Event)
  group_method = determine_group_method
  events_filtered_by_year.send(group_method, :start_time).sum(column_name)
end

def group_and_sum_by(entity, column_name)
  events_filtered_by_year = filter_events_by_month_and_year(Event)
  grouped_data = group_events_by(entity, column_name, events_filtered_by_year)
  entity_ids = grouped_data.keys
  entity_names = entity.to_s.camelize.constantize.where(id: entity_ids).pluck(:first_name, :last_name).map { |first_name, last_name| "#{first_name} #{last_name}" }
  Hash[entity_names.zip(grouped_data.values)]
end

def group_events_by(entity, column_name, events)
  group_method = determine_group_method
  events.group("#{entity}_id").send(group_method, :start_time).sum(column_name)
end

def group_and_sum_by_site(column_name)
  events_filtered_by_year = filter_events_by_month_and_year(Event)
  grouped_data = group_events_by_site(column_name, events_filtered_by_year)
  site_ids = grouped_data.keys
  site_names = Site.where(id: site_ids).pluck(:name)
  Hash[site_names.zip(grouped_data.values)]
end

def group_events_by_site(column_name, events)
  group_method = determine_group_method
  events.group(:site_id).send(group_method, :start_time).sum(column_name)
end

def filter_events_by_month_and_year(events)
  filtered_events = events

  if params[:year].present?
    year = params[:year].to_i
    filtered_events = filtered_events.where(start_time: Date.new(year)..Date.new(year).end_of_year)
  end

  if params[:month].present?
    month = params[:month].to_i
    filtered_events = filtered_events.where(start_time: Date.new(year, month)..Date.new(year, month).end_of_month)
  end

  filtered_events
end


end