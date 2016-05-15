apt_repo "docker" do
  uri "https://apt.dockerproject.org/repo"
  distribution "#{node['platform']}-#{node['lsb']['codename']}"
  components ["main"]
  keyserver "hkp://p80.pool.sks-keyservers.net:80"
  key "58118E89F3A912897C070ADBF76221572C52609D"
end

package "docker-engine"

# add jenkins to the docker group, so that it doesn't need to use
# sudo.  Alternatively, we could configure sudo such that jenkins can
# run "docker" without a password. / compare the .kitchen.docker.yml that we write.
group "docker" do
  members "jenkins"
  append true
  action :modify
  notifies :restart, "service[jenkins]"
end