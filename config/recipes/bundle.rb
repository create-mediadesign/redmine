namespace :bundle do
  desc 'Symlink "bundle" gem folder into latest release.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/bundle/ruby #{release_path}/vendor/ruby"
  end
  after 'deploy:finalize_update', 'bundle:symlink'
end
