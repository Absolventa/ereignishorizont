# configure me in config/config.yml
config_file = File.join(Rails.root, 'config', 'config.yml')

env_config  = if File.exists? config_file
                erb_config = ERB.new(File.read(config_file)).result
                (YAML.load(erb_config)[Rails.env] rescue {}).symbolize_keys
              else
                {
                  host:       ENV['EVENT_GIRL_HOST']       || 'eventgirl.example.com',
                  url_scheme: ENV['EVENT_GIRL_URL_SCHEME'] || 'https',
                  mail_from:  ENV['EVENT_GIRL_MAIL_FROM']  || 'event_girl@example.com'
                }
              end
APP_CONFIG = env_config.freeze

if Rails.env.production? or Rails.env.staging?
  ActionMailer::Base.smtp_settings = {
    address:        'smtp.sendgrid.net',
    port:           '587',
    authentication: :plain,
    user_name:      ENV['SENDGRID_USERNAME'],
    password:       ENV['SENDGRID_PASSWORD'],
    domain:         'heroku.com'
  }
  ActionMailer::Base.delivery_method = :smtp
elsif Rails.env.development?
  ActionMailer::Base.delivery_method = :sendmail
  #Mail.register_interceptor(MailInterceptor)
end
