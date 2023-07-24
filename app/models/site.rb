class Site < ApplicationRecord
  belongs_to :cdom, foreign_key: :cdom_id
  has_many :events
  has_many :mailing_lists
  has_many :favorite_sites
  has_many :users, through: :favorite_sites
  
  
  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE :query",
          query: "%#{query.downcase}%")
}

end
