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

  scope :future_events, -> { where('start_time >= ?', Date.today) }
  scope :past_events, -> { where('end_time < ?', Time.now) }
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
