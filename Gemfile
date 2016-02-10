source 'https://rubygems.org'


gem 'rails', '4.2.4'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'touchpunch-rails' # touch gestures support for jQuery UI widgets
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'execjs'
gem 'therubyracer', platforms: :ruby

# Use Devise - a flexible authentication solution (login, registration, ...)
gem 'devise'
# Authenticate through LDAP
gem 'devise_ldap_authenticatable'
# User permission management
gem 'cancan'

# questions import
gem 'nokogiri'
gem 'pandoc-ruby', '~> 1.0.0'

# student activity statistics
gem 'axlsx'

# for nice nil safeguarding
gem 'andand'

# passing data from controllers to javascript
gem 'gon'

# performance monitoring with newrelic
gem 'newrelic_rpm'

# Progress bar (for turbolinks).
gem 'nprogress-rails', '~> 0.1.6.7'

# Localization
gem 'rails-i18n'

# Reoccuring tasks
gem 'whenever', :require => false

# Error tracking
gem 'rollbar', '~> 2.7.1'

gem 'passenger'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'  # disabled for it interferes with RubyMine's debugger

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano-passenger'

  gem 'factory_girl_rails'

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'byebug'
end

