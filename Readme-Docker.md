## Things that needed to be fixed:

* upgrade json gem to 1.8.2
* upgrade rmagick gem to 2.13.4
* gem 'rvm-capistrano' needed a "require: false"
* needed to add gem 'iconv'
* needed to add gem 'test-unit'
* added the configuration files with environment vars into CVS, because we can not create files in docker container on openshift by default
* changed lib/redmine/configuration.rb to parse ERB: `yaml = YAML::load(ERB.new(File.read(filename)).result)`

## Installation/First boot

* docker-compose build
* docker-compose up
