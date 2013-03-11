# Alchemy CMS Dragonfly configuration.

# Pictures
pictures = Dragonfly[:alchemy_pictures]
pictures.configure_with :imagemagick
pictures.configure_with :rails
pictures.define_macro ActiveRecord::Base, :image_accessor
pictures.configure do |config|
  config.datastore.configure do |store|
    store.root_path = Rails.root.join('uploads/pictures').to_s
    store.store_meta = false
  end
  # You only need this if you use Dragonfly url helpers, what you not need to ;)
  # If you use the Dragonfly url helpers and you have a different mountpoint for Alchemy,
  # you have to alter this to include the mountpoint.
  config.url_format = '/pictures/:job/:basename.:format'
end



# Attachments
attachments = Dragonfly[:alchemy_attachments]
attachments.configure_with :rails
attachments.define_macro ActiveRecord::Base, :file_accessor
attachments.configure do |config|
  config.datastore.configure do |store|
    store.root_path = Rails.root.join('uploads/attachments').to_s
    store.store_meta = false
  end
end

if Alchemy::Config.get(:s3backend)==true
 [pictures, attachments].each do |app_name| 
  app_name.datastore = ::Dragonfly::DataStorage::S3DataStore.new
  app_name.datastore.configure do |s3|
     s3.bucket_name = Alchemy::Config.get(:s3_bucket) || ENV['S3_BUCKET']
     s3.access_key_id = Alchemy::Config.get(:s3_key) || ENV['S3_KEY']
     s3.secret_access_key = Alchemy::Config.get(:s3_secret) || ENV['S3_SECRET']
     # S3 Region otherwise defaults to 'us-east-1'
     s3.region = Alchemy::Config.get(:s3_region) || ENV['S3_REGION']# || 'eu-west-1'
  end
 end
end