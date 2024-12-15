class EventFilterService
  def self.filter_events(events, params, favorite_site_ids)
    new(events, params, favorite_site_ids).filter
  end

  def initialize(events, params, favorite_site_ids)
    @events = events
    @params = params
    @favorite_site_ids = favorite_site_ids
  end

  def filter
    events = filter_by_site(@events)
    events = filter_by_doctor(events)
    events
  end

  private

  attr_reader :events, :params, :favorite_site_ids

  def filter_by_site(events)
    return events unless site_filter_active?
    
    site_ids = params[:site_ids].presence || favorite_site_ids
    events.select { |event| site_ids.include?(event.site_id.to_s) }
  end

  def filter_by_doctor(events)
    return events unless doctor_filter_active?
    
    events.select { |event| params[:doctor_ids].include?(event.doctor_id.to_s) }
  end

  def site_filter_active?
    params[:site_ids].present? || favorite_site_ids.present?
  end

  def doctor_filter_active?
    params[:doctor_ids].present?
  end
end