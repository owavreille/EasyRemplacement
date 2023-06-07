# user_mailer_preview.rb
class UserMailerPreview < ActionMailer::Preview
    def weekly_events_email
      mailing_list = MailingList.first
      site = Site.first
      event = Event.first
      user = User.first
      UserMailer.weekly_events_email(mailing_list, site, event, user)
    end
  
    def booking_confirmation
      user = User.first
      event = Event.first
      UserMailer.booking_confirmation(user, event)
    end
  
    def event_update_notification
      user = User.first
      event = Event.first
      UserMailer.event_update_notification(user, event)
    end
  
    def event_cancellation_notification
      user = User.first
      event = Event.first
      UserMailer.event_cancellation_notification(user, event)
    end
  
    def new_user_notification
      user = User.first
      UserMailer.new_user_notification(user)
    end
  end
  