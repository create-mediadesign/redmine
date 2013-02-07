set(:airbrake_host)    { Capistrano::CLI.ui.ask 'Airbrake host: ', String }
set(:airbrake_api_key) { Capistrano::CLI.password_prompt 'Airbrake api key: ' }

namespace :airbrake do
  desc 'Generate the \"airbrake.rb\" configuration file.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config/initializers"
    template 'airbrake.rb.erb', "#{shared_path}/config/initializers/airbrake.rb"
  end
  after 'deploy:setup', 'airbrake:setup'
  
  desc 'Symlink "airbrake.rb" file into latest release.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/initializers/airbrake.rb #{release_path}/config/initializers/airbrake.rb"
  end
  after 'deploy:finalize_update', 'airbrake:symlink'
end
