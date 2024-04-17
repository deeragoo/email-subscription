require 'sidekiq'
require 'redis'

redis_url = 'redis://:oYbh4E5A348h7g848jesK4JpBNfnp5CP@redis-14658.c61.us-east-1-3.ec2.cloud.redislabs.com:14658/'
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end