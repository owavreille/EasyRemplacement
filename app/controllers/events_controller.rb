class EventsController < ApplicationController
  before_action :check_user_active
  before_action :set_event, only: %i[ show edit update destroy ]


  def index
    @favorite_site_ids = current_user.sites.pluck(:id).map(&:to_s)
    @doctors = Doctor.all
    @sites = Site.all
    @site = Site.find_by(id: params[:site_id])
  
    disable_booking_threshold = AppSetting.first.disable_booking_threshold.to_i
    start_date = Date.today + disable_booking_threshold.days
  
    @events = @site ? @site.events.where('start_time >= ?', start_date) : Event.where('start_time >= ?', start_date)
  
    @selected_doctor_ids = Array.wrap(params[:doctor_ids])
    @selected_site_ids = params[:site_ids].presence || @favorite_site_ids
  
    @events = @events.where(doctor_id: @selected_doctor_ids) if @selected_doctor_ids.present?
    @events = @events.where(site_id: @selected_site_ids) if @selected_site_ids.present?
  end
  
  
  # GET /events/1 or /events/1.json
  def show
    @event = Event.find(params[:id])
    @app_settings = AppSetting.find(1)
  end

  def openings
    @events = Event.where(contract_validated: true).where(opened: nil).where("start_time >= ?", Date.today)
    @pagy, @events = pagy(@events)
  end

  def opened
    @event = Event.find(params[:id])
    if @event.update(opened: true)
      flash[:notice] = "La plage a été ouverte avec succès."
      redirect_to openings_path
    else
      flash[:alert] = "Une erreur est survenue lors de la mise à jour de la plage"
    end
  end

  def paid
    @event = Event.find(params[:id])
    if @event.update(event_params.merge(paid: true))
      flash[:notice] = "Modalités de paiement enregistrées !"
      redirect_to datas_path
    else
      flash[:alert] = "Une erreur est survenue lors de la mise à jour du statut du paiement"
    end
  end

  def unpaid
    @event = Event.find(params[:id])
    if @event.update(paid: false, payment_date: nil, payment_method: nil, payment_details: nil)
      flash[:notice] = "Modalités de Paiement mises en attente"
      redirect_to datas_path
    else
      flash[:alert] = "Une erreur est survenue lors de la mise à jour du statut du paiement"
      redirect_to datas_path  # Il est bon d'avoir un chemin de redirection pour le scénario d'erreur aussi
    end
  end
  

  
  # GET /events/new
  def new
    @event = Event.new(start_time: (DateTime.now + 7.days).beginning_of_hour, end_time: (DateTime.now + 7.days + 4.hours).beginning_of_hour)
    @sites = Site.all.map { |site| [site.name, site.id] } if Site.any?
    @doctors = Doctor.all.map{ |doctor| ["Dr #{doctor.last_name}", doctor.id] } if Doctor.any?
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @sites = Site.all.map { |site| [site.name, site.id] } if Site.any?
    @doctors = Doctor.all.map{ |doctor| [doctor.last_name, doctor.id] } if Doctor.any?
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @sites = Site.all.map { |site| [site.name, site.id] } if Site.any?
    @doctors = Doctor.all.map{ |doctor| [doctor.last_name, doctor.id] } if Doctor.any?

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "La plage de remplacement a bien été créée !" }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def download_ics
    event = Event.find(params[:id])
    cal = generate_ics_for_event(event)
    send_data cal.to_ical, filename: "event_#{event.id}.ics", type: 'text/calendar'
  end
  
  private
  
  def generate_ics_for_event(event)
    require 'icalendar'
  
    cal = Icalendar::Calendar.new
    ical_event = Icalendar::Event.new
    ical_event.dtstart = event.start_time.to_datetime
    ical_event.dtend = event.end_time.to_datetime
    ical_event.summary = "Remplacement de #{event.doctor.first_name} #{event.doctor.last_name}"
    ical_event.location = event.site.name
    cal.add_event(ical_event)
    cal.publish
    cal
  end
  

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html do
          # Envoyer un e-mail de notification si l'ID de l'utilisateur de l'événement n'est pas nul
          if @event.user_id.present?
            UserMailer.event_update_notification(User.find(@event.user_id), @event).deliver_now
          end
          contract_blob = @event.contract_blob
          if contract_blob.attached?
            contract_blob.purge
          end
          redirect_to event_url(@event), notice: "La plage de remplacement a bien été mise à jour !"
        end
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    # Récupérer l'utilisateur associé à l'événement avant de le supprimer
    user = User.find(@event.user_id) if @event.user_id.present?
  
    @event.destroy
  
    respond_to do |format|
      format.html do
        # Envoyer un e-mail de notification d'annulation à l'utilisateur s'il existe
        UserMailer.event_cancellation_notification(user, @event).deliver_now if user.present?
        contract_blob = @event.contract_blob
        if contract_blob.attached?
          contract_blob.purge
        end
        redirect_to events_url, notice: "La plage de remplacement a bien été supprimée !"
      end
      format.json { head :no_content }
    end
  end
  

  def booking
    @event = Event.find(params[:id])
    user = User.find(@event.user_id) if @event.user_id.present?

     if @event.user_id.present?
      flash[:notice] = "Ce remplacement est déjà réservé."
    else
      @event.update(user_id: current_user.id)
      flash[:notice] = "Plage de Remplacement Réservée avec Succès."

      # Envoyer l'e-mail de confirmation au current_user
      UserMailer.booking_confirmation(current_user, @event).deliver_now

    # Envoyer l'e-mail de confirmation à l'utilisateur admin
    admin_users = User.where(role: true)
    admin_users.each do |admin_user|
      UserMailer.booking_confirmation(current_user, @event).deliver_now
    end
    end
    redirect_to event_path(@event)
  end 

def cancel_booking
  @event = Event.find(params[:id])
  max_replacement_cancel = AppSetting.first.max_replacement_cancel.to_i
  if @event.opened == true
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
  
  def check_user_active
    unless current_user.active?
      redirect_to pending_path(current_user)        
      end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:site_id, :doctor_id, :start_time, :end_time, :number_of_patients, :helper, :user_id, :amount, :reversion, :amount_paid, :contract_generated, :contract_validated, :editable, :patient_count, :am_min_hour, :am_max_hour, :pm_min_hour, :pm_max_hour, :contract_blob, :opened, :paid, :payment_date, :payment_method, :payment_details)
    end    
end
