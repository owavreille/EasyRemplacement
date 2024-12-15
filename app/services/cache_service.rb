
class CacheService
  def self.fetch_or_compute(key, expires_in: 1.hour)
    Rails.cache.fetch(cache_key(key), expires_in: expires_in) do
      yield
    end
  end

  def self.clear(key)
    Rails.cache.delete(cache_key(key))
  end

  def self.clear_pattern(pattern)
    Rails.cache.delete_matched("#{cache_prefix}:#{pattern}")
  end

  private

  def self.cache_key(key)
    "#{cache_prefix}:#{key}"
  end

  def self.cache_prefix
    Rails.env.production? ? "prod" : "dev"
  end
end
