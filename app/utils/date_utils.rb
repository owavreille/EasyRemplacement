module DateUtils
  def self.format_date(date, format = :default)
    case format
    when :default
      date.strftime("%d/%m/%Y")
    when :time
      date.strftime("%H:%M")
    when :datetime
      date.strftime("%d/%m/%Y %H:%M")
    when :month_year
      date.strftime("%B %Y")
    else
      date.to_s
    end
  end

  def self.beginning_of_period(year, month = nil)
    if month
      Date.new(year.to_i, month.to_i).beginning_of_month
    else
      Date.new(year.to_i).beginning_of_year
    end
  end

  def self.end_of_period(year, month = nil)
    if month
      Date.new(year.to_i, month.to_i).end_of_month
    else
      Date.new(year.to_i).end_of_year
    end
  end
end