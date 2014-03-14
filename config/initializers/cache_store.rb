ICast::Application.configure do
  config.cache_store = :redis_store,
    ENV['REDIS_CACHE_URL'] || "#{ENV['REDIS_URL']}/cache",
    { expires_in: 1.day }
end
