class DataController < ApplicationController
  before_action :require_role, only: [:index, :update_amount, :generate_contract]


  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non Autorisé."
    end
  end

  def index
    @contracts = Event.where.not(contract_blob: nil)
    @past_events = Event.where.not(user_id: nil).where('end_time < ?', Time.now)
    @upcoming_events = Event.where.not(user_id: nil).where('start_time > ?', Time.now)
    @past_pagy, @past_events = pagy(@past_events) if @past_events.present?
    @upcoming_pagy, @upcoming_events = pagy(@upcoming_events) if @upcoming_events.present?
  end

  def userdata
    @past_events = Event.where(user_id: current_user.id).where('end_time < ?', Time.now)
    @upcoming_events = Event.where(user_id: current_user.id).where('start_time > ?', Time.now)
  
    if @past_events.present?
      @past_pagy, @past_events = pagy(@past_events)
    end
  
    if @upcoming_events.present?
      @upcoming_pagy, @upcoming_events = pagy(@upcoming_events)
    end
  end

  def update_amount
  @event = Event.find(params[:id])
  amount = params[:amount]&.to_f if params[:amount].present?
  reversion = @event.reversion

  if reversion.present?
    amount_paid = amount * reversion / 100
  else
    amount_paid = 0
  end

  if @event.update(amount: amount, amount_paid: amount_paid)
    flash[:notice] = "Montant du Remplacement et Montant à Payer mis à jour avec succès."
  else
    flash[:error] = "Erreur lors de la mise à jour du Montant du remplacement."
  end

  redirect_to datas_path
end

def cancel_booking
  @event = Event.find(params[:id])
  max_replacement_cancel = AppSetting.first.max_replacement_cancel.to_i
  if @event.opened
    flash[:alert] = "La plage a été ouverte, merci de contacter le cabinet."
  elsif @event.start_time > (Date.today + max_replacement_cancel.days)
    contract_blob = @event.contract_blob
    if contract_blob.attached?
      contract_blob.purge
    end
    @event.update(user_id: nil, contract_generated: false, contract_validated: false)
    flash[:notice] = "Remplacement Annulé avec succès."
  else
    flash[:alert] = "Impossible d'annuler ce remplacement car le délai est inférieur à #{max_replacement_cancel} jours, contacter directement le cabinet !"
  end
  redirect_to userdata_path
end


end