
class AuthorizationService < BaseService
  attr_reader :user, :record, :action

  def initialize(user:, record:, action:)
    @user = user
    @record = record 
    @action = action
  end

  def call
    return failure("User not authenticated") unless user
    return failure("User not active") unless user.active?

    case action
    when :manage_admin
      authorize_admin
    when :manage_events
      authorize_event_management
    when :view_event
      authorize_event_view
    else
      failure("Unknown action")
    end
  end

  private

  def authorize_admin
    user.role? ? success : failure("Not authorized")
  end

  def authorize_event_management
    return success if user.role?
    return success if record.user_id == user.id
    failure("Not authorized")
  end

  def authorize_event_view
    return success if user.role?
    return success if record.user_id == user.id
    return success if record.public?
    failure("Not authorized")
  end
end
