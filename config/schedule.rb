job_type :runner_rbenv, "export PATH=/home/aleftng/.rbenv/shims:/home/aleftng/.rbenv/bin:/usr/bin:$PATH; eval \"$(rbenv init -)\"; cd :path && bundle exec rollbar-rails-runner -e :environment ':task' :output"

case @environment

  when 'production'
    every :day, :at => '3:00am' do
      runner_rbenv "RecommenderSystem::ActivityRecommender.update_table"
    end
  when 'staging'
    every :day, :at => '4:00am' do
      runner_rbenv "RecommenderSystem::ActivityRecommender.update_table"
    end
  when 'sandbox'
    every :day, :at => '5:00am' do
      runner_rbenv "RecommenderSystem::ActivityRecommender.update_table"
    end
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
