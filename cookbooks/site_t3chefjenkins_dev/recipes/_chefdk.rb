chef_dk 't3chefjenkins_chefdk' do
  version node['t3chefjenkins']['chefdk']['version']
  global_shell_init true
  action :install
end


if node['t3chefjenkins']['use_docker']
  %w{
  kitchen-docker
  }.each do |gem|
    gem_package gem do
      gem_binary "/opt/chefdk/embedded/bin/gem"
      options "--no-document --no-user-install"
    end
  end
end

###########################
# Chef / Knife
###########################

directory "#{node['jenkins']['master']['home']}/.chef/" do
  owner "jenkins"
  group "jenkins"
end

template "#{node['jenkins']['master']['home']}/.chef/config.rb" do
  owner "jenkins"
  group "jenkins"
  source "chef-config.rb.erb"
  variables(
    :node_name => node['t3chefjenkins']['knife_config']['node_name'],
    :chef_server_url => node['t3chefjenkins']['knife_config']['chef_server_url'],
  )
  only_if { node['t3chefjenkins']['knife_config'] && node['t3chefjenkins']['knife_config']['node_name'] }
end

# place either the client key defined in the attributes, or create only a template file
file "#{node['jenkins']['master']['home']}/.chef/client.pem" do
  owner "jenkins"
  group "jenkins"
  content node['t3chefjenkins']['knife_client_key'].gsub(/\|/, "\n") if node['t3chefjenkins']['knife_client_key']
  action :create  if node['t3chefjenkins']['knife_client_key']
  content "Manually replace this with the real client.pem!" unless node['t3chefjenkins']['knife_client_key']
  action :create_if_missing unless node['t3chefjenkins']['knife_client_key']
end
