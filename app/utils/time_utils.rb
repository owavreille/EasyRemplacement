
module TimeUtils
  def self.format_time_range(start_time, end_time)
    "#{format_time(start_time)} - #{format_time(end_time)}"
  end

  def self.format_time(time)
    time.strftime("%H:%M")
  end

  def self.format_date_time(time)
    time.strftime("%d/%m/%Y %H:%M")
  end

  def self.within_hours?(time, min_hour, max_hour)
    time_hour = time.hour
    min_hour = min_hour.to_i
    max_hour = max_hour.to_i
    
    time_hour >= min_hour && time_hour <= max_hour
  end

  def self.duration_in_hours(start_time, end_time)
    ((end_time - start_time) / 1.hour).round(2)
  end
end
