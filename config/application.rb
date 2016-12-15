require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AlefTng
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Bratislava'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :sk

    # Custom form builder.
    config.action_view.default_form_builder = 'AlefFormBuilder'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Prehladavanie adresarov s modelmi
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**/}')]

    # Autoloadable lib directories with classes and modules.
    config.autoload_paths += %W(#{config.root}/lib)

    # Core extensions
    config.autoload_paths += Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| require l }

    # Exceptions.
    config.autoload_paths += Dir[File.join(Rails.root, "lib", "exceptions.rb")].each {|l| require l }

    # Generovanie prekladov pre Javascript.
    config.middleware.use I18n::JS::Middleware
  end
end
