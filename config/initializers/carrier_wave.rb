if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      #config for aws s3
      :provider => 'AWS',
      :aws_access_key_id => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_ACCESS_KEY'],
      :region => ENV['S3_REGION']
    }
    config.fog_directory = ENV['S3_BUCKET']
  end
end
