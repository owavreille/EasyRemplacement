class Site < ApplicationRecord
  belongs_to :cdom, foreign_key: :cdom_id
  has_many :events
  has_many :mailing_lists

  attr_accessor :am_min_hour_select, :am_max_hour_select, :pm_min_hour_select, :pm_max_hour_select


end
