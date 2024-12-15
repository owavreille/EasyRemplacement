
class NotificationMailer < ApplicationMailer
  def event_creation_notification(user, event)
    @user = user
    @event = event
    mail(
      to: user.email,
      subject: 'Nouveau Remplacement Créé'
    )
  end

  def booking_confirmation(user, event)
    @user = user
    @event = event
    mail(
      to: user.email,
      subject: 'Confirmation de Remplacement'
    )
  end

  def event_update_notification(user, event)
    @user = user
    @event = event
    mail(
      to: user.email,
      subject: 'Modification d\'une plage de Remplacement'
    )
  end

  def event_cancellation_notification(user, event)
    @user = user
    @event = event
    mail(
      to: user.email,
      subject: 'Annulation d\'un Remplacement'
    )
  end
end
