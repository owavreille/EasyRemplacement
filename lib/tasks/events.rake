namespace :events do
  desc "Envoie hebdomadaire des Remplacements non réservés aux Utilisateurs Inscrits"
  task weekly_events_email: :environment do
    MailingList.all.each do |mailing_list|
      users = User.joins(:mailing_list).where(mailing_lists: { id: mailing_list.id })
      next if users.empty? # Ignore les mailing lists sans utilisateurs
      
      sites = mailing_list.site_id.present? ? [mailing_list.site] : Site.all
      sites.each do |site|
        events = Event.where(site_id: site.id, user_id: nil)
        users.each do |user|
          UserMailer.weekly_events_email(mailing_list, site, events, user).deliver_now
        end
      end
    end
  end
end
