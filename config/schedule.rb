job_type :runner_rbenv, "export PATH=/home/aleftng/.rbenv/shims:/home/aleftng/.rbenv/bin:/usr/bin:$PATH;"\
                        "eval \"$(rbenv init -)\";"\
                        "eval `/home/aleftng/load_env.rb`;"\
                        "cd :path && RAILS_ENV=:environment bundle exec rollbar-rails-runner ':task' :output" #

TIME = {
    production: '3:00am',
    staging: '4:00am',
    sandbox: '5:00am'
}

every :day, :at => TIME[@environment.to_sym] do
      runner_rbenv "RecommenderSystem::ActivityRecommender.update_table"
end

TIME2 = {
    production: '3:30am',
    staging: '4:30am',
    sandbox: '5:30am'
}

every :day, :at => TIME2[@environment.to_sym] do
      runner_rbenv "RecommenderSystem::IrtRecommender.update_table"
end

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
