
class AuditService
  def self.log_action(user:, action:, resource:, details: {})
    Rails.logger.info(
      action: action,
      user_id: user&.id,
      resource_type: resource.class.name,
      resource_id: resource.id,
      details: details,
      timestamp: Time.current
    )
  end

  def self.log_error(error:, context: {})
    Rails.logger.error(
      error_class: error.class.name,
      error_message: error.message,
      backtrace: error.backtrace&.first(5),
      context: context,
      timestamp: Time.current
    )
  end
end
