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

  bash "startwebproxy" do
    code <<-EOC
    cd /srv/www/mobile_web/current
    sudo bundle install
    sudo rake minify
EOC
  end
end
