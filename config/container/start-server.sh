#!/bin/bash
cd /rails
source /etc/profile.d/rvm.sh
bundle exec unicorn_rails -D -p 8080
nginx
