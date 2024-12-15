class ReportService
  def self.generate_monthly_report(year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    events = Event.where(start_time: start_date..end_date)

    {
      period: "#{I18n.l(start_date, format: '%B %Y')}",
      stats: StatsService.calculate_event_stats(events),
      totals: AccountingService.calculate_totals(events),
      by_site: AccountingService.calculate_totals_by_entity(events, :site),
      by_doctor: AccountingService.calculate_totals_by_entity(events, :doctor),
      by_user: AccountingService.calculate_totals_by_entity(events, :user)
    }
  end

  def self.generate_annual_report(year)
    start_date = Date.new(year, 1, 1)
    end_date = start_date.end_of_year
    events = Event.where(start_time: start_date..end_date)

    {
      period: "#{year}",
      stats: StatsService.calculate_event_stats(events),
      totals: AccountingService.calculate_totals(events),
      monthly_breakdown: generate_monthly_breakdown(events, year),
      by_site: AccountingService.calculate_totals_by_entity(events, :site),
      by_doctor: AccountingService.calculate_totals_by_entity(events, :doctor),
      by_user: AccountingService.calculate_totals_by_entity(events, :user)
    }
  end

  private

  def self.generate_monthly_breakdown(events, year)
    (1..12).map do |month|
      start_date = Date.new(year, month, 1)
      end_date = start_date.end_of_month
      monthly_events = events.where(start_time: start_date..end_date)

      {
        month: I18n.l(start_date, format: '%B'),
        stats: StatsService.calculate_event_stats(monthly_events),
        totals: AccountingService.calculate_totals(monthly_events)
      }
    end
  end
end