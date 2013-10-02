bash "install_bcrypt" do
  user "root"
  extract_path = "/home/deploy/.bundler/core/ruby/2.0.0/gems/bcrypt-ruby-3.1.1/ext/mri/"
  cwd extract_path
  code <<-EOC
    ruby extconf.rb
    make
    make install
  EOC
  if { ::File.exists?(extract_path) }
end
