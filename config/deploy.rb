require 'rvm/capistrano'
require 'bundler/capistrano'
require 'airbrake/capistrano'

set :application,     'redmine'
set :repository,      'git@github.com:create-mediadesign/redmine.git'
set :branch,          'master'
set :scm,             :git
set :deploy_to,       '/home/create/www/redmine'
set :user,            'create'
set :use_sudo,        false
set :rvm_type,        :user
set :rvm_ruby_string, '1.9.3'
server                'live.create.at', :app, :web, :db, primary: true

# Use local key instead of key installed on the server.
# If not working run "ssh-add ~/.ssh/id_rsa" on your local machine.
ssh_options[:forward_agent] = true

namespace :deploy do
  desc 'Tell Passenger to start the app.'
  task :start, roles: :app, except: { no_release: true } do
    run "cd #{current_release} && /home/create/.rvm/gems/ruby-1.9.3-p194/gems/passenger-3.0.13/bin/passenger start -a 127.0.0.1 -p 3002 -d -e production"
  end
  
  desc 'Tell Passenger to stop the app.'
  task :stop, roles: :app, except: { no_release: true } do
    run "cd #{current_release} && /home/create/.rvm/gems/ruby-1.9.3-p194/gems/passenger-3.0.13/bin/passenger stop -p 3002"
  end
  
  desc 'Tell Passenger to restart the app.'
  task :restart, roles: :app, except: { no_release: true } do
    stop
    start
  end
  
  desc 'Symlink shared configs and folders on each release.'
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/configuration.yml #{release_path}/config/configuration.yml"
    run "rm -rf #{release_path}/vendor/ruby"
    run "ln -nfs #{shared_path}/bundle/ruby #{release_path}/vendor/ruby"
    run "ln -nfs #{shared_path}/config/initializers/session_store.rb #{release_path}/config/initializers/session_store.rb"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
    run "ln -nfs #{shared_path}/config/project_types.yml #{release_path}/config/project_types.yml"
    run "ln -nfs #{shared_path}/config/initializers/airbrake.rb #{release_path}/config/initializers/airbrake.rb"
  end
end

after 'deploy:finalize_update', 'deploy:symlink_shared'
