
class ErrorHandlerService
  def self.handle_error(error, context = {})
    case error
    when ActiveRecord::RecordNotFound
      handle_not_found(error, context)
    when ActiveRecord::RecordInvalid
      handle_invalid_record(error, context)
    when StandardError
      handle_standard_error(error, context)
    end
  end

  private

  def self.handle_not_found(error, context)
    Rails.logger.error("Record not found: #{error.message}")
    Rails.logger.error("Context: #{context}")
    { error: "Resource not found", status: :not_found }
  end

  def self.handle_invalid_record(error, context)
    Rails.logger.error("Invalid record: #{error.message}")
    Rails.logger.error("Context: #{context}")
    { error: error.record.errors.full_messages, status: :unprocessable_entity }
  end

  def self.handle_standard_error(error, context)
    Rails.logger.error("Unexpected error: #{error.message}")
    Rails.logger.error("Context: #{context}")
    Rails.logger.error(error.backtrace.join("\n"))
    { error: "An unexpected error occurred", status: :internal_server_error }
  end
end
