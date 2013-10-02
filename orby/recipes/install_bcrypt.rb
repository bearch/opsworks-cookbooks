puts '-----HDKAWJHDKWJADHAWD &&&&&&&&&&&&&&&&&&&&&&&&&&&&-----------'
extract_path = "/home/deploy/.bundler/core/ruby/2.0.0/gems/bcrypt-ruby-3.1.1/ext/mri/"
bash "install_bcrypt" do
  user "root"
  cwd extract_path
  puts '-----HDKAWJHDKWJADHAWD %%%%%%%%%%%%%%%%%%%%%%%%%%-----------'
  code <<-EOC
    ruby extconf.rb
    make
    make install
EOC
end if File.exists?(extract_path)
