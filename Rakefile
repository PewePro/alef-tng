# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

directory "tmp"
 
  file "hello.tmp" => "tmp" do
    sh "echo 'Hello' >> 'tmp/hello.tmp'"
  end

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
