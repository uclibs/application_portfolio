#!/bin/bash
# Note: Change this to be the version on ruby needed on the server.
# Could change this to read the .ruby-version in the project
RUBY_VERSION=$(cat .ruby-version | sed s/ruby-//)

if rbenv versions | grep -q $RUBY_VERSION; then
    echo 'Ruby' $RUBY_VERSION 'is installed'
else
    RUBY_CONFIGURE_OPTS="--disable-dtrace" rbenv install $RUBY_VERSION
fi