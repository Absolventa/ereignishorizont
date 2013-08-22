# configure me in config/config.yml
erb_config = ERB.new(File.read(File.join(Rails.root, 'config', 'config.yml'))).result
APP_CONFIG = (YAML.load(erb_config)[Rails.env] rescue {}).symbolize_keys
