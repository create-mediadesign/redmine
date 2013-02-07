set(:smtp_address)   { Capistrano::CLI.ui.ask 'SMTP address: ', String }
set(:project_type_1) { Capistrano::CLI.ui.ask 'Project type 1: ', String }
set(:project_type_2) { Capistrano::CLI.ui.ask 'Project type 2: ', String }
set(:project_type_3) { Capistrano::CLI.ui.ask 'Project type 3: ', String }
set(:cookie_postfix) { Capistrano::CLI.ui.ask 'Cookie postfix name: ', String }

namespace :redmine do
  desc 'Generate redmine configuration app files.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config/initializers"
    
    template 'redmine_configuration.yml.erb', "#{shared_path}/config/configuration.yml"
    template 'project_types.yml.erb',         "#{shared_path}/config/project_types.yml"
    template 'secret_token.rb.erb',           "#{shared_path}/config/initializers/secret_token.rb"
    template 'session_store.rb.erb',          "#{shared_path}/config/initializers/session_store.rb"
  end
  after 'deploy:setup', 'redmine:setup'
  
  desc 'Symlink redmine configuration app files.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/configuration.yml #{release_path}/config/configuration.yml"
    run "ln -nfs #{shared_path}/config/initializers/session_store.rb #{release_path}/config/initializers/session_store.rb"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
    run "ln -nfs #{shared_path}/config/project_types.yml #{release_path}/config/project_types.yml"
  end
  after 'deploy:finalize_update', 'redmine:symlink'
end
