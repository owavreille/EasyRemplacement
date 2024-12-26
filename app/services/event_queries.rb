class EventQueries
  def self.past_events(filter_params)
    base_query = Event.includes(:site, :doctor, :user)
                     .where('start_time < ?', Time.current)
                     .order(start_time: :desc)
    
    apply_filters(base_query, filter_params)
  end

  def self.upcoming_events(filter_params)
    base_query = Event.includes(:site, :doctor, :user)
                     .where('start_time >= ?', Time.current)
                     .order(start_time: :asc)
    
    apply_filters(base_query, filter_params)
  end

  private

  def self.apply_filters(events, filter_params)
    return events unless filter_params

    if filter_params[:year].present? && filter_params[:month].present?
      start_date = Date.new(filter_params[:year].to_i, filter_params[:month].to_i)
      events = events.where('EXTRACT(YEAR FROM start_time) = ? AND EXTRACT(MONTH FROM start_time) = ?',
                          start_date.year, start_date.month)
    elsif filter_params[:year].present?
      events = events.where('EXTRACT(YEAR FROM start_time) = ?', filter_params[:year].to_i)
    end
    
    events = events.where(site_id: filter_params[:site]) if filter_params[:site].present?
    events
  end
end 