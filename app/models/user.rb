class User < ApplicationRecord
  has_one_attached :signature
  has_and_belongs_to_many :mailing_lists, optional: true
  has_many :events
  has_many :favorite_sites, dependent: :destroy
  has_many :sites, through: :favorite_sites

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

    def admin?
      role == true
    end

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
      end
    end

  scope :active, -> { where(active: true) }
  scope :admin, -> { where(role: true) }
  scope :search_by_name, ->(query) {
        where("LOWER(first_name) LIKE :query OR LOWER(last_name) LIKE :query",
              query: "%#{query.downcase}%")
  }

  TITLE_OPTIONS = ['Dr', 'M.', 'Mme']
  STATUS_OPTIONS = ["Actif", "Inactif"]
  
  # Validations
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :title, inclusion: { in: TITLE_OPTIONS, allow_nil: true }, allow_blank: true
  validates :phone, phone: { possible: true, allow_blank: true }
  validates :siret_number, format: { with: /\A\d{14}\z/, message: "doit être une suite de 14 chiffres" }, allow_blank: true
  validate :signature_size_validation
  validates :status, inclusion: { in: STATUS_OPTIONS }, allow_nil: true

  VALID_SIRET_REGEX = /\A\d{14}\z/

  validates :siret_number, format: { with: VALID_SIRET_REGEX, message: "doit être une suite de 14 chiffres" }, allow_blank: true

  def full_name
    [title, first_name, last_name].compact.join(' ')
  end

  def display_name
    full_name.presence || email
  end

  private

  def signature_size_validation
    if signature.attached? && signature.blob.byte_size > 1.megabyte
      errors.add(:signature, "La taille de la signature est trop grande. Elle doit être inférieure à 1MB.")
    end
  end

end
