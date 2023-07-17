class User < ApplicationRecord
  has_one_attached :signature
  belongs_to :mailing_list, optional: true
  has_many :events


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

  scope :search_by_name, ->(query) {
        where("LOWER(first_name) LIKE :query OR LOWER(last_name) LIKE :query",
              query: "%#{query.downcase}%")
  }

  TITLE_OPTIONS = ['Dr', 'M.', 'Mme']
  
  validates :title, inclusion: { in: TITLE_OPTIONS, allow_nil: true }, presence: false
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

end
