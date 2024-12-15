
module EventFormHelper
  def patient_count_options(event)
    if event.helper?
      event.site.min_patients_helped..event.site.max_patients_helped
    else
      event.site.min_patients..event.site.max_patients
    end
  end

  def default_patient_count(event)
    if event.helper?
      event.site.min_patients_helped
    else
      event.site.min_patients
    end
  end

  def time_slot_type(event)
    am_pm_separation = AppSetting.first.am_pm_hour_separation.hour
    
    if event.start_time.hour < am_pm_separation && event.end_time.hour < am_pm_separation
      :morning
    elsif event.start_time.hour >= am_pm_separation && event.end_time.hour >= am_pm_separation
      :afternoon
    else
      :full_day
    end
  end
end
