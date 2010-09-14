set :application, "polskitwitter"

set :scm, "git"
#set :scm_username, "domininik"
set :repository,  "git@github.com:domininik/Twittabout.git"
set :branch, "master"

server "akacja.wzks.uj.edu.pl", :app, :web, :db, :primary => true                   

set :deploy_to, "#{application}"
set :user, "fijasdom"
set :use_sudo, false
 
# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end