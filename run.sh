#!/bin/bash

cd "$(dirname $0)"

bundle exec rails s -p 3000 -b '0.0.0.0' RAILS_ENV=$ENVIRONMENT
