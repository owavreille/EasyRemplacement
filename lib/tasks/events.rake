namespace :events do
  desc "Send weekly email with events without bookings"
  task send_weekly_email: :environment do
    MailingList.all.each do |mailing_list|
      sites = mailing_list.site_id.present? ? [mailing_list.site] : Site.all
      sites.each do |site|
        events = Event.where(site_id: site.id).where.not(id: Booking.pluck(:event_id).uniq)
        UserMailer.weekly_events_email(mailing_list, site, events).deliver_now
      end
    end
  end
end
