chef_dk 't3chefjenkins_chefdk' do
  version node['t3chefjenkins']['chefdk']['version']
  global_shell_init true
  action :install
end