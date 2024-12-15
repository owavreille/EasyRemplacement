class MailingListService
  def self.send_weekly_events
    MailingList.find_each do |mailing_list|
      process_mailing_list(mailing_list)
    end
  end

  private

  def self.process_mailing_list(mailing_list)
    users = User.joins(:mailing_lists).where(mailing_lists: { id: mailing_list.id })
    return if users.empty?

    sites = mailing_list.site_id.present? ? [mailing_list.site] : Site.all
    events = Event.available.upcoming

    users.each do |user|
      NotificationMailer.weekly_events_email(mailing_list, sites, events, user).deliver_later
    end
  end
end