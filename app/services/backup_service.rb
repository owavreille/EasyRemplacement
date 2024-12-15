
class BackupService
  def self.create_backup
    timestamp = Time.current.strftime("%Y%m%d%H%M%S")
    
    {
      database: backup_database(timestamp),
      files: backup_files(timestamp),
      configurations: backup_configurations(timestamp)
    }
  end

  private

  def self.backup_database(timestamp)
    filename = "database_#{timestamp}.sql"
    path = Rails.root.join("tmp", "backups", "database", filename)
    
    FileUtils.mkdir_p(File.dirname(path))
    system("pg_dump #{database_url} > #{path}")
    
    { path: path, size: File.size(path) }
  end

  def self.backup_files(timestamp)
    filename = "files_#{timestamp}.tar.gz"
    path = Rails.root.join("tmp", "backups", "files", filename)
    
    FileUtils.mkdir_p(File.dirname(path))
    system("tar -czf #{path} #{Rails.root.join('storage')}")
    
    { path: path, size: File.size(path) }
  end

  def self.backup_configurations(timestamp)
    filename = "config_#{timestamp}.yml"
    path = Rails.root.join("tmp", "backups", "config", filename)
    
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, YAML.dump(collect_configurations))
    
    { path: path, size: File.size(path) }
  end

  def self.database_url
    Rails.configuration.database_configuration[Rails.env]
  end

  def self.collect_configurations
    {
      app_settings: AppSetting.first.as_json,
      environment: Rails.application.credentials.config,
      version: {
        ruby: RUBY_VERSION,
        rails: Rails.version,
        bundler: Bundler::VERSION
      }
    }
  end
end
