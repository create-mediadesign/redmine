source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem "jquery-rails", "~> 2.0.2"
gem "i18n", "~> 0.6.0"
gem "coderay", "~> 1.0.6"
gem "fastercsv", "~> 1.5.0", :platforms => [:mri_18, :mingw_18, :jruby]
gem "builder", "3.0.0"
gem 'capistrano'
gem 'rvm-capistrano'
gem 'airbrake'

# Optional gem for LDAP authentication
group :ldap do
  gem "net-ldap", "~> 0.3.1"
end

# Optional gem for OpenID authentication
group :openid do
  gem "ruby-openid", "~> 2.1.4", :require => "openid"
  gem "rack-openid"
end

# Optional gem for exporting the gantt to a PNG file, not supported with jruby
platforms :mri, :mingw do
  group :rmagick do
    # RMagick 2 supports ruby 1.9
    # RMagick 1 would be fine for ruby 1.8 but Bundler does not support
    # different requirements for the same gem on different platforms
    gem "rmagick", ">= 2.0.0"
  end
end

platforms :jruby do
  # jruby-openssl is bundled with JRuby 1.7.0
  gem "jruby-openssl" if Object.const_defined?(:JRUBY_VERSION) && JRUBY_VERSION < '1.7.0'
  gem "activerecord-jdbc-adapter", "1.2.5"
end

gem "mysql2", :platforms => [:mri_19, :mingw_19]

group :development do
  gem "rdoc", ">= 2.4.2"
  gem "yard"
  gem 'pry-rails'
end

group :test do
  gem "shoulda", "~> 3.3.2"
  gem "mocha"
  gem 'capybara', '~> 2.0.0'
  gem 'pry-rails'
end
