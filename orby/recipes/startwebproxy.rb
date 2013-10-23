node[:deploy].each do |application, deploy|
  service "nginx" do
    supports :restart => true, :reload => true
  end

  template "nginx.conf" do
    path "#{node[:nginx][:dir]}/nginx.conf"
    source "nginx.conf.erb"

    variables(:vars => node[:nginx_vars])

    owner "root"
    group "root"
    mode 0644
  end
end
