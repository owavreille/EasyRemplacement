class Doctor < ApplicationRecord
  has_one_attached :signature
  has_many :events, dependent: :restrict_with_error
  has_many :sites, through: :events

  TITLE_OPTIONS = ['Dr', 'M.', 'Mme']
  STATUS_OPTIONS = ['Disponible', 'Indisponible', 'Retraité']
  
  validates :title, inclusion: { in: TITLE_OPTIONS, allow_nil: true }, presence: false
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :phone, phone: { possible: true, allow_blank: true }
  validates :status, inclusion: { in: STATUS_OPTIONS }
  validate :signature_size_validation

  scope :available, -> { where(status: 'Disponible') }
  scope :ordered, -> { order(last_name: :asc, first_name: :asc) }
  scope :active, -> { where(status: 'Disponible') }
  scope :search_by_name, ->(query) {
    where("LOWER(first_name) LIKE :query OR LOWER(last_name) LIKE :query",
          query: "%#{query.downcase}%")
  }

  def full_name
    [title, first_name, last_name].compact.join(' ')
  end

  def display_name
    "Dr #{last_name}"
  end

  def status_badge
    case status
    when 'Disponible'
      'success'
    when 'Indisponible'
      'warning'
    when 'Retraité'
      'danger'
    end
  end

  def available?
    status == 'Disponible'
  end

  private

  def signature_size_validation
    if signature.attached? && signature.blob.byte_size > 1.megabyte
      errors.add(:signature, "La taille de la signature est trop grande. Elle doit être inférieure à 1MB.")
    end
  end
end
