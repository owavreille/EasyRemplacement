class Contract < ApplicationRecord
  validates :header, :body, :footer, presence: true
end
  