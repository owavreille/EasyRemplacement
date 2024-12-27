class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :download_ics]
  before_action :authorize_event, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:opened]
  before_action :set_calendar_dates, only: [:index]
  before_action :load_form_data, only: [:new, :edit, :create, :update]

  def index
    @doctors = Doctor.available.ordered
    @sites = Site.available.ordered
    @favorite_site_ids = current_user.sites.pluck(:id)

    # Initialiser les paramètres de filtre
    if params[:site_ids].blank? && params[:doctor_ids].blank?
      # Si l'utilisateur a des sites favoris, les utiliser, sinon prendre tous les sites
      params[:site_ids] = @favorite_site_ids.present? ? @favorite_site_ids.map(&:to_s) : @sites.pluck(:id).map(&:to_s)
      params[:doctor_ids] = @doctors.pluck(:id).map(&:to_s)
    end

    @filter_params = filter_params.to_h

    @events = Event.includes(:site, :doctor, :user)
                   .where('start_time >= ?', Date.today)
                   .order(start_time: :asc)

    # Appliquer les filtres
    @events = @events.filter_by(@filter_params)
                   
    @pagy, @events = pagy(@events, items: 10)
    
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
    unless can_view_event?
      redirect_to events_path, alert: "Accès non autorisé"
      return
    end
    
    @app_settings = AppSetting.first
    
    respond_to do |format|
      format.html
      format.json { render json: @event }
    end
  end

  def new
    @event = Event.new(default_event_params)
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user unless current_user.role?
    
    if @event.save
      notify_admins_of_new_event
      redirect_to event_url(@event), notice: "La plage de remplacement a bien été créée !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      notify_users_of_event_update
      redirect_to event_url(@event), notice: "La plage de remplacement a bien été mise à jour !"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @event.can_be_deleted?
      @event.destroy
      notify_users_of_event_deletion
      redirect_to events_url, notice: "La plage de remplacement a bien été supprimée !"
    else
      redirect_to events_url, alert: "Cette plage ne peut pas être supprimée."
    end
  end

  def download_ics
    unless @event
      render plain: "Événement non trouvé", status: :not_found
      return
    end

    calendar = generate_ics_calendar
    send_data calendar.to_ical, 
              type: 'text/calendar', 
              disposition: 'attachment', 
              filename: "remplacement_#{@event.id}.ics"
  end

  def openings
    @events = Event.includes(:site, :doctor, :user)
                   .where('start_time >= ?', Date.today)
                   .where.not(user_id: nil)
                   .where(contract_validated: true)
                   .where(opened: [false, nil])
                   .order(start_time: :asc)
    @pagy, @events = pagy(@events, items: 15)
  end
  
  def opened
    @event = Event.find(params[:id])
    if @event.update(opened: true)
      flash[:success] = "La plage a été marquée comme ouverte"
    else
      flash[:error] = "Impossible de marquer la plage comme ouverte"
    end
    redirect_to openings_path
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Événement non trouvé"
    redirect_to openings_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: "Événement non trouvé"
  end

  def authorize_event
    unless can_modify_event?
      redirect_to events_path, alert: "Non autorisé"
    end
  end

  def can_modify_event?
    current_user.role? || 
    (@event.user_id == current_user.id && @event.editable?)
  end

  def can_view_event?
    # Tout le monde peut voir les événements
    true
  end

  def set_calendar_dates
    @start_date = params.fetch(:start_date, Date.today)
    @start_date = Date.parse(@start_date.to_s)
  rescue ArgumentError
    @start_date = Date.today
  end

  def load_form_data
    @sites = Site.active.order(:name).map { |site| [site.name, site.id] }
    @doctors = Doctor.active.order(:last_name).map { |doc| ["Dr #{doc.last_name}", doc.id] }
  end

  def default_event_params
    {
      start_time: (DateTime.now + 7.days).beginning_of_hour,
      end_time: (DateTime.now + 7.days + 4.hours).beginning_of_hour
    }
  end

  def filter_params
    params.permit(:start_date, :end_date, site_ids: [], doctor_ids: [])
  end

  def event_params
    permitted_params = [
      :site_id, :doctor_id, :start_time, :end_time, :number_of_patients,
      :helper, :editable, :patient_count, :am_min_hour, :am_max_hour,
      :pm_min_hour, :pm_max_hour
    ]

    # Paramètres réservés aux admins
    if current_user.role?
      permitted_params += [
        :user_id, :amount, :reversion, :amount_paid, :contract_generated,
        :contract_validated, :contract_blob, :opened, :paid, :payment_date,
        :payment_method, :payment_details
      ]
    end

    params.require(:event).permit(permitted_params)
  end

  def generate_ics_calendar
    calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.dtstart = @event.start_time
    event.dtend = @event.end_time
    event.summary = "Remplacement #{@event.site.name}"
    event.description = generate_event_description
    event.location = @event.site.full_address
    
    calendar.add_event(event)
    calendar.publish
    calendar
  end

  def generate_event_description
    [
      "Remplacement du Dr #{@event.doctor.full_name}",
      "Site: #{@event.site.name}",
      "Nombre de patients: #{@event.number_of_patients}",
      "Aide opératoire: #{@event.helper? ? 'Oui' : 'Non'}"
    ].join("\n")
  end

  def notify_admins_of_new_event
    User.admin.find_each do |admin|
      NotificationMailer.event_creation_notification(admin, @event).deliver_later
    end
  end

  def notify_users_of_event_update
    (@event.interested_users + User.admin).uniq.each do |user|
      NotificationMailer.event_update_notification(user, @event).deliver_later
    end
  end

  def notify_users_of_event_deletion
    interested_users = User.admin.or(User.joins(:favorite_sites).where(favorite_sites: { site_id: @event.site_id }))
    interested_users.each do |user|
      NotificationMailer.event_cancellation_notification(user, @event).deliver_later
    end
  end
end
