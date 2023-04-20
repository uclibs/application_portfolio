
#!/bin/bash
#
# Starts the application if it's not already running
#
# Example usage: /opt/webapps/application_portfolio/current/scripts/start_appport.sh /opt/webapps/application_portfolio/current/ /application_portfolio production

APP_DIR=$1 # Directory where the app is installed
WEB_URI=$2 # The sub-URI on the web server where the app can be accessed
MODE=$3    # production or development

if ! ( [ -f $APP_DIR/tmp/puma/pid ] && pgrep -F $APP_DIR/tmp/puma/pid > /dev/null )
then
  cd $APP_DIR
  export PATH=$APP_DIR/vendor/bundle/ruby/2.6.0/bin:/usr/local/bin:$PATH
  export RAILS_ENV=$MODE
  export RAILS_RELATIVE_URL_ROOT=$WEB_URI
  bin/bundle exec puma -d
fi
