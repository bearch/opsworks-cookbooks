bash "start_web_proxy" do
  code <<-EOC
    nginx -s stop
    sudo bundle install
    rake minify
    nginx -c /srv/www/mobile_web/current/config/nginx.staging.conf -p /srv/www/mobile_web/current/
EOC
end
