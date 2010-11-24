require 'compass'
require 'compass/app_integration/rails'
Compass::AppIntegration::Rails.initialize!

Rails.configuration.middleware.insert_before('Rack::Sendfile', 'Rack::Static',
               :urls => ['/stylesheets/compiled'],
               :root => "#{Rails.root}/tmp/public")
Rails.configuration.middleware.use Rack::StaticCache, :urls => ["/stylesheets/compiled"], :duration => 2, :versioning => false