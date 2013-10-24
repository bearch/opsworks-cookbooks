node[:deploy].each do |application, deploy|
  template "nginx.conf" do
    path "#{node[:nginx][:dir]}/nginx.conf"
    source "nginx.conf.erb"

    variables(:vars => node[:nginx_vars])

    owner "root"
    group "root"
    mode 0644
    notifies :reload, "service[nginx]", :delayed
  end
end
