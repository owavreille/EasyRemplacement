class Doctor < ApplicationRecord
  has_one_attached :signature_blob

  TITLE_OPTIONS = ['Dr', 'M.', 'Mme']
  
  validates :title, inclusion: { in: TITLE_OPTIONS, allow_nil: true }, presence: false
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :search_by_name, ->(query) {
    where("LOWER(first_name) LIKE :query OR LOWER(last_name) LIKE :query",
          query: "%#{query.downcase}%")
}

end
