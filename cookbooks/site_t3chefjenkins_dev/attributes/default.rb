#<> Sets the required Java version
override['java']['jdk_version'] = '7'

#<> Sets the Java installation distribution
default['java']['install_flavor'] = 'openjdk'

#<> Sets the installation method for the Jenkins server
default['jenkins']['master']['install_method'] = 'war'

#<> Sets the default shell for the jenkins system user
default['jenkins']['master']['shell'] = '/bin/bash'

#<> Configures the Jenkins plugins to be installed on the server.
default['jenkins']['master']['plugins'] = {}

#<> Configures the ChefDK version to be installed - see https://github.com/chef/chef-dk
default['t3chefjenkins']['chefdk']['version'] = '0.12.0-1'

#<> Optionally disable usage of Docker
default['t3chefjenkins']['use_docker'] = true