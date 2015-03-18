if Rails.env.test?
  class NullStorage
    attr_reader :uploader

    def initialize(uploader)
      @uploader = uploader
    end

    def identifier
      uploader.filename
    end

    def store!(_file)
      true
    end

    def retrieve!(_identifier)
      true
    end
  end

  CarrierWave.configure do |config|
    config.storage = NullStorage
    config.enable_processing = false
  end
elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.storage                          = :file
  end
else
  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.storage                          = :fog
    config.fog_credentials                  = {
      :provider              => 'AWS',
      :aws_access_key_id     => Settings.aws.access_key_id,
      :aws_secret_access_key => Settings.aws.secret_access_key,
      :region                => 'ap-northeast-1',
      :path_style            => true
    }
    config.fog_directory                    = Settings.aws.fog_directory
    config.fog_public                       = false
    config.fog_authenticated_url_expiration = 24 * 60 * 60
  end
end
