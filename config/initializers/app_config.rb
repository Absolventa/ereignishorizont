# configure me in config/config.yml
config_file = File.join(Rails.root, 'config', 'config.yml')
begin
  erb_config = ERB.new(File.read(config_file)).result
rescue Errno::ENOENT => e
  $stderr.puts "Could not find config file '#{config_file}'"
  exit 1
end
APP_CONFIG = (YAML.load(erb_config)[Rails.env] rescue {}).symbolize_keys
