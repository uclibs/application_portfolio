FROM ruby:3.0.5-alpine
RUN apk --update --no-cache add build-base ncurses xvfb xvfb-run nodejs yarn sqlite-dev tzdata libxslt-dev libxml2-dev
RUN apk --update --no-cache add mariadb-dev

ARG RAILS_MASTER_KEY
# Set Rails to run in development
ENV RAILS_ENV='development'
ENV APP_PORTFOLIO_DATABASE_ADAPTER='sqlite3'

# Setting up a non-root User and Group inside the container
ENV RAILS_ROOT /opt/app
ENV RAILS_USER rails
ENV RAILS_USER_ID 1001
ENV RAILS_GROUP rails
ENV RAILS_GROUP_ID 1001

# Create the non-root user
RUN addgroup -S $RAILS_USER -g $RAILS_GROUP_ID && adduser -S $RAILS_USER -G $RAILS_GROUP -h $RAILS_ROOT -u $RAILS_USER_ID

USER $RAILS_USER
WORKDIR $RAILS_ROOT
# `--chown` needs have to the actual user name instead of the variable $RAILS_USER due to https://github.com/moby/moby/issues/35018,
# this issue is present in the version of the Docker used by CircleCI
COPY --chown=rails:rails Gemfile* ./
RUN gem install bundler -v "$(cat Gemfile.lock | tail -1 | tr -d ' ')" && bundle install --no-cache --jobs 20 --retry 5

COPY --chown=rails:rails . ./
RUN mkdir -p $RAILS_ROOT/tmp/puma
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]