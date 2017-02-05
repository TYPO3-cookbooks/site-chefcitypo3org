=begin
#<
ChefDK setup
#>
=end


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
