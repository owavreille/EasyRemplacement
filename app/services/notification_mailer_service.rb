
class NotificationMailerService < BaseService
  def self.send_booking_confirmation(user, event)
    new(user, event).send_booking_confirmation
  end

  def initialize(user, event)
    @user = user
    @event = event
  end

  def send_booking_confirmation
    UserMailer.booking_confirmation(@user, @event).deliver_later
    notify_admins if @user
    success
  rescue StandardError => e
    failure(e.message)
  end

  private

  def notify_admins
    User.where(role: true).find_each do |admin|
      UserMailer.booking_confirmation(admin, @event).deliver_later
    end
  end
end
