source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '~> 5.0.0.rc1'
gem 'pg'
gem 'puma'
gem 'haml'

# frontent gems
gem 'sass-rails'
gem 'uglifier' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.0.0' # Use CoffeeScript for .js.coffee assets and views
gem 'bootstrap-sass', '~> 2.3.2.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'simple_form'
gem 'select2-rails'


gem 'responders', '~> 2.0'
gem 'will_paginate'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'jbuilder', '~> 1.2' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'actionpack-xml_parser', '~> 1.0.0'
gem 'activemodel-serializers-xml'

gem 'whenever', require: false
gem 'slack-notifier'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.0'

# Use unicorn as the app server
# gem 'unicorn'

group :production do
  gem 'rails_12factor', '0.0.3'
end

group :development do
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.5.0.beta3'
  gem 'rspec-collection_matchers'
  gem 'rspec-activemodel-mocks'
end

group :test do
  gem 'rails-controller-testing'
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem "codeclimate-test-reporter", require: false
  gem 'timecop'
  gem 'zonebie'

  gem 'capybara'
  gem 'launchy'
  gem 'webmock'
end
