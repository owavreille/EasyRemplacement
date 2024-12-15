module EventQueries
  def self.upcoming_events(filters = {})
    events = Event.where('start_time >= ?', Date.today)
    
    events = filter_by_year(events, filters[:year]) if filters[:year]
    events = filter_by_month(events, filters[:month]) if filters[:month]
    events = filter_by_site(events, filters[:site]) if filters[:site]
    
    events.includes(:user, :doctor, :site)
  end

  def self.past_events(filters = {})
    events = Event.where('end_time < ?', Time.now)
    
    events = filter_by_year(events, filters[:year]) if filters[:year]
    events = filter_by_month(events, filters[:month]) if filters[:month]
    events = filter_by_site(events, filters[:site]) if filters[:site]
    
    events.includes(:user, :doctor, :site)
  end

  private

  def self.filter_by_year(events, year)
    year = year.to_i
    events.where(start_time: Date.new(year)..Date.new(year).end_of_year)
  end

  def self.filter_by_month(events, month)
    month = month.to_i
    year = Date.today.year
    events.where(start_time: Date.new(year, month)..Date.new(year, month).end_of_month)
  end

  def self.filter_by_site(events, site_id)
    events.where(site_id: site_id)
  end
end