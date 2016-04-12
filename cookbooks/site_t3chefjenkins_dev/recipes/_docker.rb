return unless node['t3chefjenkins']['use_docker']

include_recipe "apt-docker"
package "docker-engine"

# service "docker" do
#   supports [:restart]
# end

# add jenkins to the docker group, so that it doesn't need to use
# sudo.  Alternatively, we could configure sudo such that jenkins can
# run "docker" without a password. / compare the .kitchen.docker.yml that we write.
group "docker" do
  members "jenkins"
  append true
  action :modify
  notifies :restart, "service[jenkins]"
end