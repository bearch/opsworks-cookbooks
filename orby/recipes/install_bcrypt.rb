gem_path = File.dirname(`bundle exec gem which bcrypt`) + "/../ext/mri/"
bash "install_bcrypt" do
  user "root"
  cwd gem_path
  code <<-EOC
    ruby extconf.rb
    make
    make install
  EOC
end if File.exists?(gem_path)
