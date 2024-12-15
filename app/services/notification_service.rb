
class NotificationService
  def self.notify_creation(event)
    return unless event.user_id
    
    user = User.find(event.user_id)
    NotificationMailer.event_creation_notification(user, event).deliver_later
    notify_admins_about_creation(event)
  end

  def self.notify_booking(user, event)
    return unless user
    
    NotificationMailer.booking_confirmation(user, event).deliver_later
    notify_admins_about_booking(event)
  end

  def self.notify_cancellation(user, event)
    return unless user
    NotificationMailer.event_cancellation_notification(user, event).deliver_later
  end

  def self.notify_update(user, event)
    return unless user
    NotificationMailer.event_update_notification(user, event).deliver_later
  end

  private

  def self.notify_admins_about_creation(event)
    User.where(role: true).find_each do |admin|
      NotificationMailer.event_creation_notification(admin, event).deliver_later
    end
  end

  def self.notify_admins_about_booking(event)
    User.where(role: true).find_each do |admin|
      NotificationMailer.booking_confirmation(admin, event).deliver_later
    end
  end
end
