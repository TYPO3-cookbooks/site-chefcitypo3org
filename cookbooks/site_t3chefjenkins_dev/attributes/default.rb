#<> Sets the required Java version
override['java']['jdk_version'] = '7'

#<> Sets the Java installation distribution
default['java']['install_flavor'] = 'openjdk'

#<> Sets the default shell for the jenkins system user
default['jenkins']['master']['shell'] = '/bin/bash'

#<> Configures the Jenkins plugins to be installed on the server.
default['jenkins']['master']['plugins'] = {}

#<> Configures the ChefDK version to be installed - see https://github.com/chef/chef-dk
default['t3chefjenkins']['chefdk']['version'] = '0.12.0-1'

#<> Configures the version of Chef to use for test-kitchen runs
default['t3chefjenkins']['kitchen']['chef_version'] = "12.5.1"

#<> Optionally disable usage of Docker
default['t3chefjenkins']['use_docker'] = true

#<> The knife/chef configuration for communicating with the Chef API
default['t3chefjenkins']['knife_config'] = nil

#<> Optionally (for local testing), the contents of a chef admin's key (\n replaced with |)
default['t3chefjenkins']['knife_client_key'] = nil
