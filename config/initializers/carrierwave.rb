CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'

  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJ6L6AVJBLUDZNQXQ',
    :aws_secret_access_key  => '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',
  }
  config.fog_directory  = 'etherpros'
end