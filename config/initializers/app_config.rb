# configure me in config/config.yml
config_file = File.join(Rails.root, 'config', 'config.yml')
begin
  erb_config = ERB.new(File.read(config_file)).result
rescue Errno::ENOENT => e
  $stderr.puts "Could not find config file '#{config_file}'"
  exit 1
end
APP_CONFIG = (YAML.load(erb_config)[Rails.env] rescue {}).symbolize_keys

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