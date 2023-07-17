class Event < ApplicationRecord
  belongs_to :site
  belongs_to :doctor
  belongs_to :user, optional: true
  has_one_attached :contract_blob

  validate :end_time_after_start_time
  validates_presence_of :reversion
  validate :check_minimal_replacement_length

  def check_minimal_replacement_length
    if am_min_hour.present? && am_max_hour.present? && (am_max_hour - am_min_hour) / 1.hour < minimal_replacement_length
      errors.add(:am_max_hour, "La durée minimale du remplacement est de #{minimal_replacement_length} heures.")
    elsif pm_min_hour.present? && pm_max_hour.present? && (pm_max_hour - pm_min_hour) / 1.hour < minimal_replacement_length
      errors.add(:pm_max_hour, "La durée minimale du remplacement est de #{minimal_replacement_length} heures.")
    elsif am_min_hour.present? && pm_max_hour.present? && (pm_max_hour - am_min_hour) / 1.hour < minimal_replacement_length
      errors.add(:pm_max_hour, "La durée minimale du remplacement est de #{minimal_replacement_length} heures.")
    end
  end

  
  private

  def end_time_after_start_time
    if end_time.present? && start_time.present? && end_time <= start_time
      errors.add(:end_time, "doit être postérieure à l'heure de début")
    end
  end
end
