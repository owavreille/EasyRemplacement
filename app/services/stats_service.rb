class StatsService
  def self.calculate_event_stats(events)
    {
      total_events: events.count,
      total_amount: events.sum(:amount),
      total_paid: events.sum(:amount_paid),
      average_amount: calculate_average(events, :amount),
      average_duration: calculate_average_duration(events),
      most_active_site: find_most_active_site(events),
      most_active_doctor: find_most_active_doctor(events),
      most_active_user: find_most_active_user(events)
    }
  end

  private

  def self.calculate_average(events, field)
    return 0 if events.empty?
    events.average(field)&.round(2) || 0
  end

  def self.calculate_average_duration(events)
    return 0 if events.empty?
    
    total_duration = events.sum do |event|
      (event.end_time - event.start_time) / 1.hour
    end
    
    (total_duration / events.count).round(2)
  end

  def self.find_most_active_site(events)
    Site.joins(:events)
        .where(events: { id: events.select(:id) })
        .group('sites.id')
        .order('COUNT(events.id) DESC')
        .first
  end

  def self.find_most_active_doctor(events)
    Doctor.joins(:events)
          .where(events: { id: events.select(:id) })
          .group('doctors.id')
          .order('COUNT(events.id) DESC')
          .first
  end

  def self.find_most_active_user(events)
    User.joins(:events)
        .where(events: { id: events.select(:id) })
        .group('users.id')
        .order('COUNT(events.id) DESC')
        .first
  end
end