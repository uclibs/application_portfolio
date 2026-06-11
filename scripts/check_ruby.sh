#!/bin/bash
# QA and production deploy hosts manage Ruby with rbenv (user apache, /home/apache/.rbenv).
# Runs during cap deploy via ruby_update_check, before bundler:config/install.
# Installs the version from .ruby-version when missing.
RUBY_VERSION=$(cat .ruby-version | sed s/ruby-//)

if rbenv versions | grep -q $RUBY_VERSION; then
    echo 'Ruby' $RUBY_VERSION 'is installed'
else
    git -C /home/apache/.rbenv/plugins/ruby-build pull
    RUBY_CONFIGURE_OPTS="--disable-dtrace" rbenv install $RUBY_VERSION
fi
