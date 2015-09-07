#!/usr/local/bin/ruby

# 0. set the values // fetch them from environment:

environment = ENV["ENVIRONMENT"]
db_host     = ENV["DB_HOST"]
db_port     = ENV["DB_PORT"]
db_user     = ENV["DB_USER"]
db_password = ENV["DB_PASSWORD"]
db_database = ENV["DB_DATABASE"]
smtp_host   = ENV["SMTP_HOST"]
smtp_port   = ENV["SMTP_PORT"]
smtp_user   = ENV["SMTP_USER"]
smtp_password=ENV["SMTP_PASSWORD"]
airbrake_api_key= ENV["AIRBRAKE_API_KEY"]
secret_key   =ENV["SECRET_KEY"]

# 1. config/database.yml

File.open('config/database.yml', 'w') do |f|
  f.write %{
#{environment}:
  adapter: mysql2
  encoding: utf8
  database: #{db_database}
  username: #{db_user}
  password: #{db_password}
  host: #{db_host}
  port: #{db_port}
  }
end

# 2. config/configuration.yml

File.open('config/configuration.yml', 'w') do |f|
  f.write %{
# = Redmine configuration file
#
# Each environment has it's own configuration options.  If you are only
# running in production, only the production block needs to be configured.
# Environment specific configuration options override the default ones.
#
# Note that this file needs to be a valid YAML file.
# DO NOT USE TABS! Use 2 spaces instead of tabs for identation.
#
# == Outgoing email settings (email_delivery setting)
#
# === Common configurations
#
# ==== Sendmail command
#
# production:
#   email_delivery:
#     delivery_method: :sendmail
#
# ==== Simple SMTP server at localhost
#
#{environment}:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: #{smtp_host}
      port: #{smtp_port}
      authentication: :login
      user_name: "#{smtp_user}"
      password: "#{smtp_password}"

  # Absolute path to the directory where attachments are stored.
  # The default is the 'files' directory in your Redmine instance.
  # Your Redmine instance needs to have write permission on this
  # directory.
  # Examples:
  # attachments_storage_path: /var/redmine/files
  # attachments_storage_path: D:/redmine/files
  attachments_storage_path:

  # Configuration of the autologin cookie.
  # autologin_cookie_name: the name of the cookie (default: autologin)
  # autologin_cookie_path: the cookie path (default: /)
  # autologin_cookie_secure: true sets the cookie secure flag (default: false)
  autologin_cookie_name:
  autologin_cookie_path:
  autologin_cookie_secure:

  scm_subversion_command:
  scm_mercurial_command:
  scm_git_command:
  scm_cvs_command:
  scm_bazaar_command:
  scm_darcs_command:

  database_cipher_key: '#{secret_key}'

  # Set this to false to disable plugins' assets mirroring on startup.
  # You can use `rake redmine:plugins:assets` to manually mirror assets
  # to public/plugin_assets when you install/upgrade a Redmine plugin.
  #
  #mirror_plugins_assets_on_startup: false

  # Your secret key for verifying cookie session data integrity. If you
  # change this key, all old sessions will become invalid! Make sure the
  # secret is at least 30 characters and all random, no regular words or
  # you'll be exposed to dictionary attacks.
  #
  # If you have a load-balancing Redmine cluster, you have to use the
  # same secret token on each machine.
  secret_token: '#{secret_key}'
  }
end

# 3. config/project_types.yml

File.open('config/project_types.yml', 'w') do |f|
  f.write %{
- intern Routine
- Kundenauftrag
- Kundenprojekt
- Forschungsprojekt
- intern Auftrag/Projekt
- Dummy
- Not defined
  }
end

# 4. config/initializers/airbrake.rb

File.open('config/initializers/airbrake.rb', 'w') do |f|
  f.write %{
Airbrake.configure do |config|
  config.api_key  = '#{airbrake_api_key}'
end
  }
end

# 5. config/initializers/secret_token.rb

File.open('config/initializers/secret_token.rb', 'w') do |f|
  f.write %{
RedmineApp::Application.config.secret_token = '#{secret_key}'
  }
end

# 6. config/initializers/session_store.rb

File.open('config/initializers/session_store.rb', 'w') do |f|
  f.write %{
RedmineApp::Application.config.session_store :cookie_store, key: '_redmine_session'
  }
end
