
class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_event, only: [:edit, :update, :destroy]
  before_action :set_calendar_dates, only: [:index]
  before_action :load_form_data, only: [:new, :edit]

  def index
    @favorite_site_ids = current_user.sites.pluck(:id).map(&:to_s)
    @doctors = Doctor.all
    @sites = Site.all
    @events = Event.future_events
    @filter_params = filter_params
  end

  def show
    @app_settings = AppSetting.first
  end

  def new
    @event = Event.new(default_event_params)
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    
    if @event.save
      redirect_to event_url(@event), notice: "La plage de remplacement a bien été créée !"
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to event_url(@event), notice: "La plage de remplacement a bien été mise à jour !"
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: "La plage de remplacement a bien été supprimée !"
  end

def download_ics
    @event = Event.find_by(id: params[:id]) # Remplacez `find_by` par `find` si vous êtes sûr que l'événement existe
    if @event.nil?
      render plain: "Event not found", status: :not_found
      return
    end

    def openings
      @events = Event.includes(:site, :doctor, :user)
                     .where(contract_validated: true, opened: nil)
                     .where('start_time >= ?', Date.today)
                     .order(start_time: :asc)
      @upcoming_pagy, @events = pagy(@events)
    end
    
    def opened
      @event = Event.find(params[:id])
      if @event.update(opened: true)
        redirect_to openings_path, notice: "La plage a été marquée comme ouverte"
      else
        redirect_to openings_path, alert: "Impossible de marquer la plage comme ouverte"
      end
    end
    
    calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.dtstart = @event.start_time.strftime("%Y%m%dT%H%M%S")
    event.dtend = @event.end_time.strftime("%Y%m%dT%H%M%S")
    event.summary = "Remplacement #{@event.site.name}"
    event.description = "Remplacement du Dr #{@event.doctor.last_name}"
    
    calendar.add_event(event)
    calendar.publish

    send_data calendar.to_ical, type: 'text/calendar', disposition: 'attachment', filename: 'event.ics'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event
    unless current_user.role? || @event.user_id == current_user.id
      redirect_to events_path, alert: "Non autorisé"
    end
  end

  def set_calendar_dates
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today
  end

  def load_form_data
    @sites = Site.all.map { |site| [site.name, site.id] }
    @doctors = Doctor.all.map { |doctor| ["Dr #{doctor.last_name}", doctor.id] }
  end

  def default_event_params
    {
      start_time: (DateTime.now + 7.days).beginning_of_hour,
      end_time: (DateTime.now + 7.days + 4.hours).beginning_of_hour
    }
  end

  def filter_params
    params.permit(:start_date, doctor_ids: [], site_ids: [])
  end

  def event_params
    params.require(:event).permit(
      :site_id, :doctor_id, :start_time, :end_time, :number_of_patients,
      :helper, :user_id, :amount, :reversion, :amount_paid, :contract_generated,
      :contract_validated, :editable, :patient_count, :am_min_hour, :am_max_hour,
      :pm_min_hour, :pm_max_hour, :contract_blob, :opened, :paid, :payment_date,
      :payment_method, :payment_details
    )
  end
end
