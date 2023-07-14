#!/bin/bash

if [ ! -f "$(dirname "$(dirname "$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" )" )" )/static/.env.production" ]; then
    echo "Missing updated .env.production file in the static directory. The server may not function properly"
else
    cp "$(dirname "$(dirname "$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" )" )" )/static/.env.production" "$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" )"
fi

export RAILS_RELATIVE_URL_ROOT=/application_portfolio
export RAILS_ENV=production

# Check if puma is started
if ! ( [ -f /opt/webapps/application_portfolio/current/tmp/puma/pid ] && pgrep -F /opt/webapps/application_portfolio/current/tmp/puma/pid > /dev/null )
then
    sudo systemctl start puma-appport.service
else
    sudo systemctl restart puma-appport.service
fi
