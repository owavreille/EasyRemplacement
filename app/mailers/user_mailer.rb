class UserMailer < ApplicationMailer
  def weekly_events_email(mailing_list, site, event, user)
    @mailing_list = mailing_list
    @site = site
    @event = event
    @user = user
    mail(to: @user.email, subject: "Remplacements à venir :")
  end
  
    def booking_confirmation(user, event)
      @user = user
      @event = event
      mail(to: @user.email, subject: 'Confirmation de Remplacement')
    end
  
    def event_update_notification(user, event)
      @user = user
      @event = event
      mail(to: @user.email, subject: 'Modification d\'une plage de Remplacement')
    end
  
    def event_cancellation_notification(user, event)
      @user = user
      @event = event
      mail(to: @user.email, subject: 'Annulation d\'un Remplacement')
    end
  
    def new_user_notification(user)
      @user = user
      admins = User.where(role: true)
      mail(to: admins.pluck(:email), subject: 'Nouvel utilisateur enregistré')
    end
  end
  