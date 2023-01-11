FROM ruby:2.7.6
RUN apt-get update -qq && apt-get install -y nodejs npm
RUN npm install -g yarn
RUN gem install bundler -v 2.1.4
RUN mkdir /app
WORKDIR /app
ADD . /app
