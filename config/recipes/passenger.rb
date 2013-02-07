namespace :passenger do
  desc 'Start passenger standalone server on port 3000.'
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_release} && /home/#{user}/.rvm/gems/#{rvm_ruby_string}/gems/passenger-3.0.19/bin/passenger start -a 127.0.0.1 -p 3002 -d -e #{rails_env}"
  end
  
  desc 'Stop passenger standalone server on port 3000.'
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_release} && /home/#{user}/.rvm/gems/#{rvm_ruby_string}/gems/passenger-3.0.19/bin/passenger stop -p 3002"
  end
  
  desc 'Restart passenger standalone server on port 3000.'
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
  after 'deploy:restart', 'passenger:restart'
end
