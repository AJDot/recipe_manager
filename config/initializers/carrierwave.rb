require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'carrierwave/storage/fog'
require 'fog/aws'

CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: 'us-east-1',

  }
  config.fog_directory = ENV['S3_BUCKET_NAME']
  config.fog_public = false
  config.fog_attributes = {
    cache_control: "public, max-age=#{365.days.to_i}"
  }
end