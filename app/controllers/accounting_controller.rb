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
    when "month"
      @amount = Event.group_by_month(:start_time).sum(:amount)
    when "year"
      @amount = Event.group_by_year(:start_time).sum(:amount)
    else
      @amount = Event.group_by_month(:start_time).sum(:amount)
    end
  end

  def amount_paid
    @amount_paid = Event.group_by_month(:start_time).sum(:amount_paid)
    case params[:group_by]
    when "month"
      @amount_paid = Event.group_by_month(:start_time).sum(:amount_paid)
    when "year"
      @amount_paid = Event.group_by_year(:start_time).sum(:amount_paid)
    else
      @amount_paid = Event.group_by_month(:start_time).sum(:amount_paid)
    end
  end

  
  def amount_by_site
    case params[:group_by]
    when "month"
      @amount_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount)
    when "year"
      @amount_by_site = Event.group(:site_id).group_by_year(:start_time).sum(:amount)
    else
      @amount_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount)
    end
  
    site_ids = @amount_by_site.keys
    site_names = Site.where(id: site_ids).pluck(:name)
  
    @amount_by_site = Hash[site_names.zip(@amount_by_site.values)]
  end
  
  
  def amount_paid_by_site
    case params[:group_by]
    when "month"
      @amount_paid_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount_paid)
    when "year"
      @amount_paid_by_site = Event.group(:site_id).group_by_year(:start_time).sum(:amount_paid)
    else
      @amount_paid_by_site = Event.group(:site_id).group_by_month(:start_time).sum(:amount_paid)
    end
  
    site_ids = @amount_paid_by_site.keys
    site_names = Site.where(id: site_ids).pluck(:name)
  
    @amount_paid_by_site = Hash[site_names.zip(@amount_paid_by_site.values)]
  end
  
  

  def amount_by_doctor
    case params[:group_by]
    when "month"
      @amount_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount)
    when "year"
      @amount_by_doctor = Event.group(:doctor_id).group_by_year(:start_time).sum(:amount)
    else
      @amount_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount)
    end
  
    doctor_ids = @amount_by_doctor.keys
    doctor_names = Doctor.where(id: doctor_ids).pluck(:first_name, :last_name).map { |first_name, last_name| "#{first_name} #{last_name}" }
  
    @amount_by_doctor = Hash[doctor_names.zip(@amount_by_doctor.values)]
  end
  
  def amount_paid_by_doctor
    case params[:group_by]
    when "month"
      @amount_paid_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount_paid)
    when "year"
      @amount_paid_by_doctor = Event.group(:doctor_id).group_by_year(:start_time).sum(:amount_paid)
    else
      @amount_paid_by_doctor = Event.group(:doctor_id).group_by_month(:start_time).sum(:amount_paid)
    end
  
    doctor_ids = @amount_paid_by_doctor.keys
    doctor_names = Doctor.where(id: doctor_ids).pluck(:first_name, :last_name).map { |first_name, last_name| "#{first_name} #{last_name}" }
  
    @amount_paid_by_doctor = Hash[doctor_names.zip(@amount_paid_by_doctor.values)]
  end
  
  
  def amount_by_user
    case params[:group_by]
    when "month"
      @amount_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount)
    when "year"
      @amount_by_user = Event.group(:user_id).group_by_year(:start_time).sum(:amount)
    else
      @amount_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount)
    end
  
    user_ids = @amount_by_user.keys
    user_names = User.where(id: user_ids).pluck(:first_name, :last_name).map { |first_name, last_name| "#{first_name} #{last_name}" }
  
    @amount_by_user = Hash[user_names.zip(@amount_by_user.values)]
  end
  
  
  def amount_paid_by_user
    case params[:group_by]
    when "month"
      @amount_paid_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount_paid)
    when "year"
      @amount_paid_by_user = Event.group(:user_id).group_by_year(:start_time).sum(:amount_paid)
    else
      @amount_paid_by_user = Event.group(:user_id).group_by_month(:start_time).sum(:amount_paid)
    end
  
    user_ids = @amount_paid_by_user.keys
    user_names = User.where(id: user_ids).pluck(:first_name, :last_name).map { |first_name, last_name| "#{first_name} #{last_name}" }
  
    @amount_paid_by_user = Hash[user_names.zip(@amount_paid_by_user.values)]
  end
  
end
