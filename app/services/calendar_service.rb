class CalendarService
  def self.generate_ics(event)
    calendar = Icalendar::Calendar.new
    calendar.add_event(create_ical_event(event))
    calendar.publish
    calendar
  end

  private

  def self.create_ical_event(event)
    ical_event = Icalendar::Event.new
    ical_event.dtstart = event.start_time.to_datetime
    ical_event.dtend = event.end_time.to_datetime
    ical_event.summary = event_summary(event)
    ical_event.location = event.site.name
    ical_event
  end

  def self.event_summary(event)
    "Remplacement de #{event.doctor.first_name} #{event.doctor.last_name}"
  end
end