bash "start_web_proxy" do
  code <<-EOC
    cd /srv/www/mobile_web/current
    sudo nginx -s stop
    sudo bundle install
    sudo rake minify
    sudo nginx -c /srv/www/mobile_web/current/config/nginx.staging.conf -p /srv/www/mobile_web/current/
EOC
end
