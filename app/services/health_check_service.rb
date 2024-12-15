
class HealthCheckService
  def self.check_system_health
    {
      database: check_database,
      cache: check_cache,
      storage: check_storage,
      email: check_email,
      dependencies: check_dependencies
    }
  end

  private

  def self.check_database
    ActiveRecord::Base.connection.execute("SELECT 1")
    { status: "ok" }
  rescue StandardError => e
    { status: "error", message: e.message }
  end

  def self.check_cache
    Rails.cache.write("health_check", "ok")
    result = Rails.cache.read("health_check")
    { status: result == "ok" ? "ok" : "error" }
  rescue StandardError => e
    { status: "error", message: e.message }
  end

  def self.check_storage
    storage = ActiveStorage::Blob.service
    { status: storage.exist?("health_check") ? "ok" : "error" }
  rescue StandardError => e
    { status: "error", message: e.message }
  end

  def self.check_email
    ActionMailer::Base.deliveries.clear
    UserMailer.health_check_email.deliver_now
    { status: "ok" }
  rescue StandardError => e
    { status: "error", message: e.message }
  end

  def self.check_dependencies
    {
      redis: check_redis,
      sidekiq: check_sidekiq
    }
  end

  def self.check_redis
    Redis.new.ping == "PONG" ? { status: "ok" } : { status: "error" }
  rescue StandardError => e
    { status: "error", message: e.message }
  end

  def self.check_sidekiq
    Sidekiq::ProcessSet.new.size.positive? ? { status: "ok" } : { status: "error" }
  rescue StandardError => e
    { status: "error", message: e.message }
  end
end
