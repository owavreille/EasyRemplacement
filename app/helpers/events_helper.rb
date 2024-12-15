module EventsHelper
  def format_date(date)
    date.strftime("%d/%m/%Y")
  end

  def format_time(time)
    time.strftime("%H:%M")
  end

  def format_doctor_name(doctor)
    "Dr #{doctor.first_name} #{doctor.last_name}"
  end

  def format_user_name(user)
    return unless user
    "#{user.first_name} #{user.last_name}"
  end

  def format_boolean(value)
    value ? "oui" : "non"
  end

  def format_schedule_times(event)
    times = []
    times << "#{format_time(event.am_min_hour)} - #{format_time(event.am_max_hour)}" if event.am_min_hour && event.am_max_hour
    times << "#{format_time(event.pm_min_hour)} - #{format_time(event.pm_max_hour)}" if event.pm_min_hour && event.pm_max_hour
    times.join(" / ")
  end
end