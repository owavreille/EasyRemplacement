class Cdom < ApplicationRecord
    has_many :sites

    scope :search_by_name, ->(query) {
    where("LOWER(departement) LIKE :query",
          query: "%#{query.downcase}%")
}
end
