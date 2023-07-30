class UserMailer < ApplicationMailer
  def weekly_events_email(mailing_list, site, events, user)
    @mailing_list = mailing_list
    @site = site
    @events = events
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

    def cdom_with_attachment(email, event, contract_content)
      @event = event
      @contract_content = contract_content
  
      attachments["contrat_#{event.id}.html"] = {
        mime_type: "text/html",
        content: @contract_content
      }
  
      mail(to: email, subject: "Contrat validé - Événement ##{event.id}")
    end

  end
  