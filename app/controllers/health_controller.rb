class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    health_status = {
      status: "ok",
      timestamp: Time.current,
      database: database_connected?,
      version: Rails.version
    }

    render json: health_status
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.active?
  rescue StandardError
    false
  end
end 