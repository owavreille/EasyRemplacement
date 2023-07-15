class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :check_user_active

# GET /events or /events.json
def index
  @doctors = Doctor.all
  @sites = Site.all
  @site = Site.find_by(id: params[:site_id])
  @events = @site ? @site.events.where('start_time >= ?', Date.today) : Event.where('start_time >= ?', Date.today)

  @selected_doctor_ids = Array.wrap(params[:doctor_ids])

  @selected_site_ids = Array.wrap(params[:site_ids])

  @events = @events.where(doctor_id: @selected_doctor_ids) if @selected_doctor_ids.present?
  @events = @events.where(site_id: @selected_site_ids) if @selected_site_ids.present?
end


  # GET /events/1 or /events/1.json
  def show
    @event = Event.find(params[:id])
  end

  def list
    @events = @site ? @site.events.where('start_time >= ?', Date.today) : Event.where('start_time >= ?', Date.today)
    @event = Event.all
    @site = Site.find_by(id: params[:site_id])

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

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html do
          # Envoyer un e-mail de notification si l'ID de l'utilisateur de l'événement n'est pas nul
          if @event.user_id.present?
            UserMailer.event_update_notification(User.find(@event.user_id), @event).deliver_now
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
  
  def check_user_active
    unless current_user.active?
      redirect_to inactive_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:site_id, :doctor_id, :start_time, :end_time, :number_of_patients, :helper, :user_id, :amount, :reversion, :amount_paid, :contract_generated, :contract_validated, :editable, :patient_count, :am_min_hour, :am_max_hour, :pm_min_hour, :pm_max_hour, :contract_blob)
    end    
end
