node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  template "#{deploy[:deploy_to]}/current/config/initializers/00_orby_config_values.rb" do
  # template "#{deploy[:deploy_to]}/shared/config/orby_config_values.rb" do
    source "orby_config_values.rb"
    cookbook 'orby'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    
    if deploy[:orby_config_values]
      variables(:orby_config_values => deploy[:orby_config_values])
    elsif deploy[:graphical_config_values]
      variables(:orby_config_values => deploy[:graphical_config_values])
    end

    #create sym link
    # link "#{deploy[:deploy_to]}/current/config/initializers/00_orby_config_values.rb" do
    #   to "#{deploy[:deploy_to]}/shared/config/orby_config_values.rb"
    # end

    notifies :run, "execute[restart Rails app #{application}]"

    # only_if do
    #   File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    # end
  end


end