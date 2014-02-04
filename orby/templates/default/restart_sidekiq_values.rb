#!/bin/bash

function stop_sidekiq_for {
    stop_sidekiq "<%= @sidekiq_config_values[:pids_path] %>/sidekiq_$1.pid"
}

function stop_sidekiq {
  if [ -f $1 ]
  then
  kill -TERM `cat $1` || true
  rm -rf $1
  fi
}

function start_sidekiq_default_queue {
  bundle exec sidekiq \
    -e $1 \
    -P $2 \
    -C $3 \
    -L $4  \
    -d \
    -q notifier -q importer -q default
}

function start_sidekiq_special_queue {
  bundle exec sidekiq \
      -e  <%= @sidekiq_config_values[:rack_env] %> \
      -P "<%= @sidekiq_config_values[:pids_path] %>/sidekiq_$1.pid" \
      -L "<%= @sidekiq_config_values[:log_path] %>/sidekiq_$1.log"  \
  -c 1 \
  -d \
  -q $1
}


cd <%= @sidekiq_config_values[:current_path] %>

stop_sidekiq_for default
stop_sidekiq_for enterprise_notifications
stop_sidekiq_for app_store_notifications
stop_sidekiq_for apns_worker
stop_sidekiq_for foursquare_importer
stop_sidekiq_for yelp_importer
stop_sidekiq_for business_importer


sleep 10

start_sidekiq_default_queue <%= @sidekiq_config_values[:rack_env] %> \
                            <%= @sidekiq_config_values[:pids_path] %>/sidekiq_default.pid \
                            <%= @sidekiq_config_values[:current_path] %>/config/sidekiq.yml \
                            <%= @sidekiq_config_values[:log_path] %>/sidekiq.log

start_sidekiq_special_queue enterprise_notifications
start_sidekiq_special_queue app_store_notifications
start_sidekiq_special_queue apns_worker
start_sidekiq_special_queue foursquare_importer
start_sidekiq_special_queue yelp_importer
start_sidekiq_special_queue business_importer
