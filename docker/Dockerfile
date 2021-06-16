FROM ruby:2.6.5-alpine
RUN apk --update --no-cache add build-base ncurses xvfb xvfb-run nodejs yarn sqlite-dev tzdata libxslt-dev libxml2-dev
RUN apk --update --no-cache add mariadb-dev

ARG RAILS_MASTER_KEY
# Set Rails to run in development
ENV RAILS_ENV='development'
ENV APP_PORTFOLIO_DATABASE_ADAPTER='sqlite3'

ENV RAILS_ROOT /var/www/app_portfolio
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT
COPY Gemfile* ./
RUN gem install bundler -v "$(cat Gemfile.lock | tail -1 | tr -d ' ')" && bundle install --no-cache --jobs 20 --retry 5

COPY . ./
RUN mkdir -p $RAILS_ROOT/tmp/puma
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]