=begin
#<
Set up the SSH known hosts
#>
=end

ssh_known_hosts_entry "github.com"
ssh_known_hosts_entry "review.typo3.org" do
  port 29_418
end

# Prepare SSH key setup of jenkins user

directory "#{node['jenkins']['master']['home']}/.ssh/" do
  owner "jenkins"
  group "jenkins"
end

file "#{node['jenkins']['master']['home']}/.ssh/id_rsa" do
  content "Replace this file contents with the private key"
  owner "jenkins"
  group "jenkins"
  mode 0600
  action :create_if_missing
end
