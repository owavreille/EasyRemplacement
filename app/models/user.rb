class User < ApplicationRecord
  has_one_attached :signature_blob
  belongs_to :mailing_list, optional: true
  has_many :events


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def admin?
     role == true
  end

  TITLE_OPTIONS = ['Dr', 'M.', 'Mme']
  
  validates :title, inclusion: { in: TITLE_OPTIONS, allow_nil: true }, presence: false
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

end
