#!/bin/bash

function stop_sidekiq_for {
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
    -q default,notifier,importer
}

cd <%= @sidekiq_config_values[:current_path] %>

#Sidekiq Default
<% @pid_file_default = "#{@sidekiq_config_values[:pids_path]}/sidekiq_default.pid" %>

stop_sidekiq_for <%=@pid_file_default %>

sleep 10

start_sidekiq_default_queue <%=@sidekiq_config_values[:rack_env] %> \
                                  <%=@pid_file_default%> \
                                  <%=@sidekiq_config_values[:current_path]%>/config/sidekiq.yml
                                  <%=@sidekiq_config_values[:log_path]%>/sidekiq.log
