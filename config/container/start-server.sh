#!/bin/bash
cd /rails
source /etc/profile.d/rvm.sh
bundle exec rails s -p 80
# bundle exec unicorn -D -p 8080
# nginx
