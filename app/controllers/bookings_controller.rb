class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_user_active

  def create
    result = BookingService.book_event(@event, current_user)
    
    if result
      redirect_to root_path, 
                  notice: "Plage de Remplacement Réservée avec Succès."
    else
      redirect_to root_path, 
                  alert: "Ce remplacement est déjà réservé ou n'est plus disponible."
    end
  end

  def destroy
    result = BookingService.cancel_booking(@event)
    
    if result
      redirect_to root_path, 
                  notice: "Remplacement Annulé avec succès."
    else
      redirect_to root_path, 
                  alert: cancel_booking_error_message
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def check_user_active
    unless current_user&.active?
      redirect_to pending_path, 
                  alert: "Votre compte n'est pas encore activé."
    end
  end

  def cancel_booking_error_message
    if @event.opened
      "La plage a été ouverte, merci de contacter le cabinet."
    else
      "Impossible d'annuler ce remplacement car le délai est inférieur à " \
      "#{AppSetting.first.max_replacement_cancel} jours"
    end
  end
end
