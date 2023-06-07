class AccountingController < ApplicationController
  before_action :require_role

  def require_role
    unless current_user&.role == true
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
  
    def index
      amount
      amount_paid
      amount_by_site
      amount_paid_by_site
      amount_by_doctor
      amount_paid_by_doctor
      amount_by_user
      amount_paid_by_user
      @event = Event.all
      @doctor = Doctor.all
      @user = User.all
      @site = Site.all
    end

      def amount
        @amount = Event.group_by_month(:start_time).sum(:amount)
        case params[:group_by]
        when 'month'
          @amount = Event.group_by_month(:start_time).sum(:amount)
        when 'year'
          @amount = Event.group_by_year(:start_time).sum(:amount)
        else
          @amount = Event.group_by_month(:start_time).sum(:amount)
        end
      end
    
      def amount_paid
        @amount_paid = Event.group_by_month(:start_time).sum(:amount_paid)
        case params[:group_by]
        when 'month'
          @amount_paid = Event.group_by_month(:start_time).sum(:amount_paid)
        when 'year'
          @amount_paid = Event.group_by_year(:start_time).sum(:amount_paid)
        else
          @amount_paid = Event.group_by_month(:start_time).sum(:amount_paid)
        end
      end
          
      def amount_by_site
        @amount_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount)
        case params[:group_by]
        when 'month'
          @amount_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount)
        when 'year'
          @amount_by_site = Event.group(:site_id).group_by_year(:start_time).sum(:amount)
        else
          @amount_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount)
        end
      end
    
      def amount_paid_by_site
        @amount_paid_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount_paid)
        case params[:group_by]
        when 'month'
          @amount_paid_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount_paid)
        when 'year'
          @amount_paid_by_site = Event.group(:site_id).group_by_year(:start_time).sum(:amount_paid)
        else
          @amount_paid_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount_paid)
        end
      end
          
      def amount_by_doctor
        @amount_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount)
        case params[:group_by]
        when 'month'
          @amount_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount)
        when 'year'
          @amount_by_doctor = Event.group(:doctor_id).group_by_year(:start_time).sum(:amount)
        else
          @amount_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount)
        end
      end
    
      def amount_paid_by_doctor
        @amount_paid_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount_paid)
        case params[:group_by]
        when 'month'
          @amount_paid_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount_paid)
        when 'year'
          @amount_paid_by_doctor = Event.group(:doctor_id).group_by_year(:start_time).sum(:amount_paid)
        else
          @amount_paid_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount_paid)
        end
      end
    
      def amount_by_user
        @amount_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount)
        case params[:group_by]
        when 'month'
          @amount_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount)
        when 'year'
          @amount_by_user = Event.group(:user_id).group_by_year(:start_time).sum(:amount)
        else
          @amount_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount)
        end
      end
    
      def amount_paid_by_user
        @amount_paid_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount_paid)
        case params[:group_by]
        when 'month'
          @amount_paid_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount_paid)
        when 'year'
          @amount_paid_by_user = Event.group(:user_id).group_by_year(:start_time).sum(:amount_paid)
        else
          @amount_paid_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount_paid)
        end
      end

  end
  