set :application, "polskitwitter"

set :scm, "git"
#set :scm_username, "domininik"
set :repository,  "git@github.com:domininik/Twittabout.git"
set :branch, "master"

server "akacja.wzks.uj.edu.pl", :app, :web, :db, :primary => true                   

set :deploy_to, "/fijasdom/#{application}"
set :user, "fijasdom"
set :use_sudo, false

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end