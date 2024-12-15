module CalendarHelper
  def hidden_fields_for_filters
    return unless @filter_params
    
    safe_join([
      hidden_field_tag_multiple('doctor_ids[]', @filter_params[:doctor_ids]),
      hidden_field_tag_multiple('site_ids[]', @filter_params[:site_ids])
    ])
  end

  def calendar_date_format(date)
    date.strftime("%d/%m/%Y")
  end

  def calendar_td_classes(day, today)
    classes = []
    classes << "today" if day == today
    classes << "past" if day < today
    classes << "future" if day > today
    classes.join(" ")
  end

  private

  def hidden_field_tag_multiple(name, values)
    return if values.blank?
    
    safe_join(
      values.map { |value| hidden_field_tag(name, value, id: nil) }
    )
  end
end