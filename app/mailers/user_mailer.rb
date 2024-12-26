class UserMailer < ApplicationMailer
  def weekly_events_email(mailing_list, site, events, user)
    @mailing_list = mailing_list
    @site = site
    @events = events
    @user = user
    mail(to: @user.email, subject: "Remplacements à venir :")
  end
  
    def booking_confirmation(user, event)
      @user = user
      @event = event
      mail(to: @user.email, subject: 'Confirmation de Remplacement')
    end
  
    def event_update_notification(user, event)
      @user = user
      @event = event
      mail(to: @user.email, subject: 'Modification d\'une plage de Remplacement')
    end
  
    def event_cancellation_notification(user, event)
      @user = user
      @event = event
      mail(to: @user.email, subject: 'Annulation d\'un Remplacement')
    end
  
      def new_user_notification(admin_user, new_user)
        @admin_user = admin_user
        @new_user = new_user
        
        # Utilisation de find_each pour une meilleure performance
        User.where(role: true).find_each do |admin|
          begin
            mail(
              to: admin.email,
              subject: 'Nouvel Utilisateur Enregistré sur la plateforme de Remplacement'
            ).deliver_now
          rescue StandardError => e
            Rails.logger.error "Erreur d'envoi de mail à #{admin.email}: #{e.message}"
            next
          end
        end
      end

      def cdom_with_attachment(email, event, contract_content)
        @event = event
        @contract_content = contract_content
      
        begin
          attachments["contrat_#{event.id}.html"] = {
            mime_type: "text/html",
            content: @contract_content
          }
          
          mail(
            to: email,
            subject: "Contrat validé - Événement ##{event.id}"
          )
        rescue StandardError => e
          Rails.logger.error "Erreur d'envoi du contrat CDOM: #{e.message}"
          raise
        end
      end      

  end
  