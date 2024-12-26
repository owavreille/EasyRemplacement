class MailingList < ApplicationRecord
  belongs_to :site
  has_rich_text :text
  
  validates :name, presence: true
  validates :site_id, presence: true
end
