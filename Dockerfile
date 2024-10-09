FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
&&  apt-get install -y nodejs

WORKDIR /intuitus

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD rm -f tmp/pids/server.pid \
&& bundle exec rails server -b 0.0.0.0 -p 3000
