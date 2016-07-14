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

# FontAwesome icon font.
gem 'font-awesome-rails', '~> 4.5', '>= 4.5.0.1'

# passing data from controllers to javascript
gem 'gon'

# Small library to provide the Rails I18n translations on the JavaScript.
gem "i18n-js", ">= 3.0.0.rc11"

# performance monitoring with newrelic
gem 'newrelic_rpm'

# Progress bar (for turbolinks).
gem 'nprogress-rails', '~> 0.1.6.7'

# Localization
gem 'rails-i18n'

# Gem to hide, not destroy an ActiveRecord object.
gem "paranoia", "~> 2.0"


# Ruby library for Markdown processing that smells like butterflies and popcorn.
gem 'redcarpet', '3.3.4'

# Reoccuring tasks
gem 'whenever', :require => false

# Error tracking
gem 'rollbar', '~> 2.8.3'

gem 'passenger'

# ENV for local development
gem 'figaro', '~> 1.1'
gem 'capistrano-figaro', '~> 1.0'

# Send notifications to Slack about Capistrano deployments.
gem 'slackistrano', '2.0.1'

# gem for R
gem 'rinruby', :require => false

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.3.5'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano-passenger', '0.0.2'

  # Capybara helps you test web applications by simulating how a real user would interact with your app.
  gem 'capybara', '2.6.2'

  # Strategies for cleaning databases.
  gem 'database_cleaner', '~> 1.5', '>= 1.5.1'

  # helps you find and manage missing and unused translations
  gem 'parser', '~> 2.2.2.6'
  gem 'i18n-tasks', '0.8.7'

  # Fixtures replacement with a straightforward definition syntax.
  gem 'factory_girl_rails', '~> 4.0'

  # Rspec
  gem 'rspec-rails', '~> 3.4', '>= 3.4.1'

  # WebDriver is a tool for writing automated tests of websites
  gem 'selenium-webdriver', '2.50.0'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
end

group :development do
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

