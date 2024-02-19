#!/bin/sh
bundle exec rails db:prepare

bundle exec rails assets:clobber
bundle exec rails assets:precompile

rm -f tmp/pids/server.pid

$@
