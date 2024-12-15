class EventNotificationService
  def self.notify_booking(user, event)
    return unless user
    
    UserMailer.booking_confirmation(user, event).deliver_later
    notify_admins_about_booking(event)
  end

  def self.notify_update(user, event)
    return unless user
    UserMailer.event_update_notification(user, event).deliver_later
  end

  def self.notify_cancellation(user, event)
    return unless user
    UserMailer.event_cancellation_notification(user, event).deliver_later
  end

  private

  def self.notify_admins_about_booking(event)
    User.where(role: true).find_each do |admin|
      UserMailer.booking_confirmation(admin, event).deliver_later
    end
  end
end