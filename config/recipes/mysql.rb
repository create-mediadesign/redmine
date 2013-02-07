set(:mysql_user)     { Capistrano::CLI.ui.ask 'MySQL user: ', String }
set(:mysql_password) { Capistrano::CLI.password_prompt 'MySQL password: ' }
set(:mysql_database) { Capistrano::CLI.ui.ask 'MySQL database: ', String }

namespace :mysql do
  desc 'Generate the \"database.yml\" configuration file.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template 'mysql.yml.erb', "#{shared_path}/config/database.yml"
  end
  after 'deploy:setup', 'mysql:setup'
  
  desc 'Symlink the "database.yml" file into latest release.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after 'deploy:finalize_update', 'mysql:symlink'
end
