node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  sidekiq_path = "#{deploy[:deploy_to]}/current/bin/restart_sidekiq"

  execute "restart sidekiq #{application}" do
    cwd deploy[:current_path]
    command sidekiq_path
    action :nothing
  end


  template sidekiq_path do
    source "restart_sidekiq_values.rb"
    cookbook 'orby'
    mode "0777"

    group deploy[:group]
    owner deploy[:user]

    puts "------------------------------------Here is the magic---------------------------"
    puts "Deploy Values: #{deploy}"
    puts "Deploy value for orby_config_values with symbol: #{deploy[:orby_config_values]}"
    puts "Deploy value for orby_config_values with text: #{deploy['orby_config_values']}"    
    puts "------------------------------------Here is the magic---------------------------"
    
    
    return unless deploy && deploy[:deploy_to] && deploy[:orby_config_values]

    puts "Creating file..."

    sidekiq_confiq_values = {
        :current_path => "#{ deploy[:deploy_to] }/current",
        :install_path => "#{ deploy[:deploy_to] }/current/bin",
        :pids_path => "#{ deploy[:deploy_to] }/shared/pids",
        :log_path => "#{ deploy[:deploy_to] }/shared/log",
        :rack_env => "#{ deploy[:orby_config_values][:RACK_ENV] }"
    }
    variables( :sidekiq_config_values => sidekiq_confiq_values)

    notifies :run, "execute[restart sidekiq #{application}]"

  end


end
