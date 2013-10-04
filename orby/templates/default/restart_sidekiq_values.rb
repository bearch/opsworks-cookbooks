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

function start_sidekiq_special_queue {
  bundle exec sidekiq \
  -e $1 \
  -P $2 \
  -L $3  \
  -c 1 \
  -d \
  -q $4
}


cd <%= @sidekiq_config_values[:current_path] %>

#Sidekiq Default
<% @pid_file_default = "#{@sidekiq_config_values[:pids_path]}/sidekiq_default.pid" %>
<% @pid_file_enterprise = "#{@sidekiq_config_values[:pids_path]}/sidekiq_enterprise.pid" %>
<% @pid_file_appstore = "#{@sidekiq_config_values[:pids_path]}/sidekiq_appstore.pid" %>

stop_sidekiq_for <%=@pid_file_default %>
stop_sidekiq_for <%=@pid_file_enterprise %>
stop_sidekiq_for <%=@pid_file_appstore %>

sleep 10

start_sidekiq_default_queue <%=@sidekiq_config_values[:rack_env] %> \
                                  <%=@pid_file_default%> \
                                  <%=@sidekiq_config_values[:current_path]%>/config/sidekiq.yml \
                                  <%=@sidekiq_config_values[:log_path]%>/sidekiq.log

start_sidekiq_special_queue <%=@sidekiq_config_values[:rack_env] %> \
                                  <%=@pid_file_enterprise%> \
                                  <%=@sidekiq_config_values[:log_path]%>/sidekiq_enterprise.log \
                                  enterprise_notifications

start_sidekiq_special_queue <%=@sidekiq_config_values[:rack_env] %> \
                                  <%=@pid_file_appstore%> \
                                  <%=@sidekiq_config_values[:log_path]%>/sidekiq_appstore.log \
                                  app_store_notifications