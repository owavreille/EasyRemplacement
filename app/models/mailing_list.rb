class MailingList < ApplicationRecord
  has_rich_text :text
  belongs_to :site
  has_many :users

  def recipient_emails
    if site.present?
      site.users.pluck(:email)
    else
      User.pluck(:email)
    end
  end

  def self.send_emails
    all.each do |mailing_list|
      mailing_list.recipient_emails.each do |recipient_email|
        MailingListMailer.send_mailing_list(mailing_list, recipient_email).deliver_now
      end
    end
  end

end
