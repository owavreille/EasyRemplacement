class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAIL_FROM', 'no-reply@easyremplacement.fr')
  layout 'mailer'
end

