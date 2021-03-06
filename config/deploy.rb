# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'aleftng'
set :repo_url, 'git@github.com:PewePro/alef-tng.git'

set :rbenv_type, :user
set :rbenv_ruby, '2.2.0'


server 'aleftng.fiit.stuba.sk', user: 'aleftng', roles: %w{web app db}

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

load 'lib/exceptions.rb'
include Exceptions
set :rollbar_token, (ENV['ALEFTNG_ROLLBAR_ACCESS_TOKEN'] || (raise ApplicationConfigurationIncomplete))
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

set :slack_webhook, "https://hooks.slack.com/services/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"

if File.exist?("config/deploy_id_rsa")
  set :ssh_options, keys: ["config/deploy_id_rsa"]
end

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
