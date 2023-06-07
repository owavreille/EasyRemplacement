class Site < ApplicationRecord
  belongs_to :cdom, foreign_key: :cdom_id
  has_many :events
  has_many :mailing_lists


end
