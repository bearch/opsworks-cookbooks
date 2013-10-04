#!/bin/bash

function stop_sidekiq_for {
  if [ -f $1 ]
  then
  kill -TERM `cat $1` || true
  rm -rf $1
  fi
}

cd <%= @sidekiq_config_values[:current_path] %>

#Sidekiq Default
<% @pid_file_default = "#{@sidekiq_config_values[:pids_path]}/sidekiq_default.pid" %>

stop_sidekiq_for <%=@pid_file_default %>


#Sidekiq Enterprise Queue


bundle exec sidekiq \
        -e <%=@sidekiq_config_values[:rack_env] %> \
        -P <%=@pid_file_default%> \
        -C <%=@sidekiq_config_values[:current_path]%>/config/sidekiq.yml \
        -L <%=@sidekiq_config_values[:log_path]%>/sidekiq.log  \
        -d \
        -q default,notifier,importer

