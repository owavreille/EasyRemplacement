class Event < ApplicationRecord
  belongs_to :site
  belongs_to :doctor
  belongs_to :user, optional: true
  has_one_attached :contract_blob

  validate :end_time_after_start_time
  validates_presence_of :reversion
  private

  def end_time_after_start_time
    if end_time.present? && start_time.present? && end_time <= start_time
      errors.add(:end_time, "doit être postérieure à l'heure de début")
    end
  end
end
