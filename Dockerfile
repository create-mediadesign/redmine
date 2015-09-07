FROM ruby:2.2.2
MAINTAINER René Groß <rg@create.at>

RUN apt-get update -qq && apt-get install -y build-essential libmysqlclient-dev imagemagick libmagickwand-dev libmagickcore-dev && apt-get clean

RUN mkdir /src
WORKDIR /src
ADD Gemfile /src/Gemfile
ADD Gemfile.lock /src/Gemfile.lock
RUN bundle install

ADD . /src

EXPOSE 3000

CMD ./run.sh
