=begin
#<
ChefDK setup
#>
=end


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
    node_name: node['site-chefcitypo3org']['knife_config'].key?('node_name') ? node['site-chefcitypo3org']['knife_config']['node_name'] : "jenkins",
    chef_server_url: node['site-chefcitypo3org']['knife_config']['chef_server_url'] || "https://chef.typo3.org"
  )
end

# place either the client key defined in the attributes, or create only a template file
file "#{node['jenkins']['master']['home']}/.chef/client.pem" do
  owner "jenkins"
  group "jenkins"
  content node['site-chefcitypo3org']['knife_client_key'].tr("|", "\n") if node['site-chefcitypo3org']['knife_client_key']
  action :create if node['site-chefcitypo3org']['knife_client_key']
  content "Manually replace this with the real client.pem!" unless node['site-chefcitypo3org']['knife_client_key']
  action :create_if_missing unless node['site-chefcitypo3org']['knife_client_key']
end

###########################
# Test-Kitchen
###########################

directory "#{node['jenkins']['master']['home']}/.kitchen/" do
  owner "jenkins"
  group "jenkins"
end

template "#{node['jenkins']['master']['home']}/.kitchen/config.yml" do
  owner "jenkins"
  group "jenkins"
  source "kitchen-default.yml.erb"
end
