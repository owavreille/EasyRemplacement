class Doctor < ApplicationRecord
  has_one_attached :signature

  TITLE_OPTIONS = ['Dr', 'M.', 'Mme']
  
  validates :title, inclusion: { in: TITLE_OPTIONS, allow_nil: true }, presence: false
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :signature_size_validation

  validates :phone, phone: true


  scope :search_by_name, ->(query) {
    where("LOWER(first_name) LIKE :query OR LOWER(last_name) LIKE :query",
          query: "%#{query.downcase}%")
}

private

def signature_size_validation
  if signature.attached? && signature.blob.byte_size > 1.megabyte
    errors.add(:signature, "La taille de la signature est trop grande. Elle doit être inférieure à 1MB.")
  end
end

end
