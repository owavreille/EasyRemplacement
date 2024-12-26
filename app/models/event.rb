class Event < ApplicationRecord
  PAYMENT_METHOD = ['Virement bancaire', 'Chèque', 'Espèces']
  PAYMENT_STATUS = ['En attente', 'Payé', 'Annulé']

  belongs_to :site
  belongs_to :doctor
  belongs_to :user, optional: true
  has_one_attached :contract_blob

  validates :start_time, :end_time, presence: true
  validates :reversion, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :payment_status, inclusion: { in: PAYMENT_STATUS }, allow_nil: true
  validate :end_time_after_start_time
  validate :check_minimal_replacement_length

  scope :future_events, -> { 
    end_of_next_year = Time.current.end_of_year + 1.year
    where('start_time >= ? AND start_time <= ?', Time.current, end_of_next_year)
      .order(start_time: :asc)
  }
  scope :past_events, -> { where('start_time < ?', Time.current).order(start_time: :desc) }
  scope :opened_events, -> { where(opened: true) }
  scope :pending_openings, -> { 
    future_events
      .where(opened: true)
      .where(contract_validated: false)
      .or(where(contract_generated: false))
      .order(start_time: :asc)
  }
  scope :upcoming_with_contract, ->(user) { 
    where(user: user)
      .where(contract_generated: true, contract_validated: nil)
      .where('start_time >= ?', Time.now)
  }
  scope :pending_contracts, -> {
    where(contract_generated: nil)
      .where.not(user_id: nil)
      .where('start_time >= ?', Date.today)
  }
  scope :to_be_planned, -> {
    where(contract_validated: true, opened: nil)
      .where('start_time >= ?', Date.today)
  }
  scope :available, -> { where(user_id: nil) }
  scope :upcoming, -> { where('start_time > ?', Time.current) }

  def paid?
    payment_status == 'Payé'
  end

  def amount_paid
    return 0 unless amount
    (amount * reversion / 100.0).round(2)
  end

  def payment_status_badge
    case payment_status
    when 'Payé'
      'Fait !'
    when 'Annulé'
      'Annulé'
    else
      'En attente'
    end
  end

  def self.filter_by(params)
    events = all

    if params[:start_date].present?
      start_date = Date.parse(params[:start_date].to_s)
      events = events.where('DATE(start_time) >= ?', start_date)
    end

    if params[:end_date].present?
      end_date = Date.parse(params[:end_date].to_s)
      events = events.where('DATE(end_time) <= ?', end_date)
    end

    if params[:doctor_ids].present?
      events = events.where(doctor_id: params[:doctor_ids])
    end

    if params[:site_ids].present?
      events = events.where(site_id: params[:site_ids])
    end

    events
  end

  def self.accessible_by(user)
    if user.role?
      all
    else
      where(user_id: user.id)
    end
  end

  def can_be_deleted?
    return true if editable?
    return false if contract_validated?
    return false if start_time <= Date.today
    true
  end

  def mark_as_opened
    update(opened: true)
  end

  def interested_users
    User.where(id: user_id).or(User.where(site: site))
  end

  private

  def end_time_after_start_time
    return unless start_time && end_time
    
    if end_time <= start_time
      errors.add(:end_time, "doit être postérieure à l'heure de début")
    end
  end

  def check_minimal_replacement_length
    return unless start_time && end_time
    
    duration = (end_time - start_time) / 1.hour
    min_length = AppSetting.first.minimal_replacement_length

    if duration < min_length
      errors.add(:base, "La durée minimale du remplacement est de #{min_length} heures.")
    end
  end
end
