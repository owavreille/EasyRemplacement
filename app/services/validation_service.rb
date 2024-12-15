
class ValidationService < BaseService
  def self.validate_event(event)
    new(event).validate_event
  end

  def initialize(event)
    @event = event
  end

  def validate_event
    return failure("Invalid date range") unless valid_date_range?
    return failure("Invalid time range") unless valid_time_range?
    return failure("Invalid duration") unless valid_duration?
    return failure("Invalid reversion") unless valid_reversion?
    success
  end

  private

  attr_reader :event

  def valid_date_range?
    event.start_time < event.end_time
  end

  def valid_time_range?
    TimeUtils.within_hours?(event.start_time, event.site.am_min_hour, event.site.pm_max_hour)
  end

  def valid_duration?
    duration = TimeUtils.duration_in_hours(event.start_time, event.end_time)
    duration >= AppSetting.first.minimal_replacement_length
  end

  def valid_reversion?
    ValidationUtils.valid_percentage?(event.reversion)
  end
end
