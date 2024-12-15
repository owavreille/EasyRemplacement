
class BookingService
  def self.book_event(event, user)
    return false unless can_book?(event)
    
    ActiveRecord::Base.transaction do
      event.update!(user: user)
      NotificationMailer.booking_confirmation(user, event).deliver_later
      true
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def self.can_book?(event)
    return false unless event && event.user_id.nil?
    
    threshold = AppSetting.first.disable_booking_threshold
    event.start_time > (Date.today + threshold.days)
  end

  def self.cancel_booking(event)
    return false unless can_cancel?(event)
    
    ActiveRecord::Base.transaction do
      event.update!(
        user_id: nil,
        contract_generated: false,
        contract_validated: false
      )
      event.contract_blob.purge if event.contract_blob.attached?
      true
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def self.can_cancel?(event)
    return false unless event && event.user_id.present?
    
    max_days = AppSetting.first.max_replacement_cancel
    event.start_time > (Date.today + max_days.days) && !event.opened
  end
end
