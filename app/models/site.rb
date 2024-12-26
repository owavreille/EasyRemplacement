class Site < ApplicationRecord
  belongs_to :cdom, foreign_key: :cdom_id
  has_many :events, dependent: :restrict_with_error
  has_many :mailing_lists
  has_many :favorite_sites
  has_many :users, through: :favorite_sites
  has_many :doctors, through: :events

  STATUS_OPTIONS = ['Ouvert', 'Fermé temporairement', 'Fermé définitivement']

  validates :name, presence: true
  validates :address, presence: true
  validates :postal_code, presence: true
  validates :city, presence: true
  validates :status, inclusion: { in: STATUS_OPTIONS }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone, phone: { possible: true, allow_blank: true }
  
  scope :available, -> { where(status: 'Ouvert') }
  scope :ordered, -> { order(name: :asc) }
  scope :active, -> { where(status: 'Ouvert') }
  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE :query",
          query: "%#{query.downcase}%")
  }

  def full_address
    [address, postal_code, city].compact.join(', ')
  end

  def display_name
    name
  end

  def status_badge
    case status
    when 'Ouvert'
      'success'
    when 'Fermé temporairement'
      'warning'
    when 'Fermé définitivement'
      'danger'
    end
  end

  def available?
    status == 'Ouvert'
  end
end
