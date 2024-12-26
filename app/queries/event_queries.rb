module EventQueries
  def self.upcoming_events(filters = {})
    events = Event.where('DATE(start_time) >= ?', Date.today)
                 .where.not(user_id: nil)
    
    events = filter_by_year(events, filters[:year]) if filters[:year]
    events = filter_by_month(events, filters[:month], filters[:year]) if filters[:month]
    events = filter_by_site(events, filters[:site]) if filters[:site]
    
    events.includes(:user, :doctor, :site).order('start_time ASC')
  end

  def self.past_events(filters = {})
    events = Event.where('DATE(end_time) < ?', Date.today)
                 .where.not(user_id: nil)
    
    events = filter_by_year(events, filters[:year]) if filters[:year]
    events = filter_by_month(events, filters[:month], filters[:year]) if filters[:month]
    events = filter_by_site(events, filters[:site]) if filters[:site]
    
    events.includes(:user, :doctor, :site).order('start_time DESC')
  end

  private

  def self.filter_by_year(events, year)
    year = year.to_i
    start_date = Date.new(year, 1, 1).beginning_of_year
    end_date = start_date.end_of_year
    events.where(start_time: start_date..end_date)
  end

  def self.filter_by_month(events, month, year = nil)
    month = month.to_i
    year = (year || Date.today.year).to_i
    start_date = Date.new(year, month, 1).beginning_of_month
    end_date = start_date.end_of_month
    events.where(start_time: start_date..end_date)
  end

  def self.filter_by_site(events, site_id)
    events.where(site_id: site_id)
  end
end