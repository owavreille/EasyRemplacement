class MailingList < ApplicationRecord
  has_rich_text :text
  belongs_to :site
  has_many :users

end
