
class EventService < BaseService
  attr_reader :event, :params, :current_user

  def initialize(event: nil, params: {}, current_user: nil)
    @event = event
    @params = params
    @current_user = current_user
  end

  def create
    Event.transaction do
      @event = Event.new(params)
      
      if @event.save
        NotificationService.notify_creation(@event)
        success(event: @event)
      else
        failure(@event.errors.full_messages.join(", "))
      end
    end
  rescue StandardError => e
    failure(e.message)
  end

  def update
    Event.transaction do
      if @event.update(params)
        handle_contract_blob
        NotificationService.notify_update(@event.user, @event)
        success(event: @event)
      else
        failure(@event.errors.full_messages.join(", "))
      end
    end
  rescue StandardError => e
    failure(e.message)
  end

  def destroy
    Event.transaction do
      user = @event.user
      if @event.destroy
        NotificationService.notify_cancellation(user, @event)
        success
      else
        failure(@event.errors.full_messages.join(", "))
      end
    end
  rescue StandardError => e
    failure(e.message)
  end

  private

  def handle_contract_blob
    return unless @event.saved_change_to_contract_validated?
    
    if @event.contract_validated?
      ContractService.handle_validation(@event)
    end
  end
end
