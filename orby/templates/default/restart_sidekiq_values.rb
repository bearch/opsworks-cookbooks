#!/bin/bash

cd <%= @sidekiq_config_values[:current_path] %>

<% @pid_file_default = "#{@sidekiq_config_values[:pids_path]}/sidekiq_default.pid" %>

if [ -f <%=@pid_file_default%> ]
then
kill -TERM `cat <%=@pid_file_default%>` || true
rm -rf <%=@pid_file_default%>
fi

bundle exec sidekiq \
        -e <%=@sidekiq_config_values[:rack_env] %> \
        -P <%=@pid_file_default%> \
        -C <%=@sidekiq_config_values[:current_path]%>/config/sidekiq.yml \
        -L <%=@sidekiq_config_values[:log_path]%>/sidekiq.log  \
        -d \
        -q default,notifier,importer

