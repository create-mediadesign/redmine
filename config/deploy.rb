require 'bundler/capistrano'
require 'rvm/capistrano'
require 'airbrake/capistrano'

load 'deploy/assets'
load 'config/recipes/base'
load 'config/recipes/rvm'
load 'config/recipes/redmine'
load 'config/recipes/airbrake'
load 'config/recipes/mysql'
load 'config/recipes/bundle'
load 'config/recipes/passenger'

set :application,     'redmine'
set :user,            'create'
set :use_sudo,        false
set :deploy_to,       '/home/create/www/redmine'

server                'live.create.at', :app, :web, :db, primary: true
set :repository,      'git@github.com:create-mediadesign/redmine.git'
set :scm,             :git
set :branch,          'master'

ssh_options[:forward_agent] = true
