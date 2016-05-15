#<> Public URL of the Jenkins master
defaul['site-chefcitypo3org']['url'] = "https://chef-ci.typo3.org"

#<> Install Jenkins LTS
default['jenkins']['master']['repository'] = "http://pkg.jenkins-ci.org/debian-stable"

#<> Sets the required Java version
override['java']['jdk_version'] = '7'

#<> Sets the Java installation distribution
default['java']['install_flavor'] = 'openjdk'

#<> Sets the default shell for the jenkins system user
default['jenkins']['master']['shell'] = '/bin/bash'

#<> Configures the Jenkins plugins to be installed on the server.
default['jenkins']['master']['plugins'] = {}

#<> Configures the ChefDK version to be installed - see https://github.com/chef/chef-dk
default['site-chefcitypo3org']['chefdk']['version'] = '0.13.21-1'

#<> Configures the version of Chef to use for test-kitchen runs
default['site-chefcitypo3org']['kitchen']['chef_version'] = "12.5.1"

#<> The knife/chef configuration for communicating with the Chef API
default['site-chefcitypo3org']['knife_config'] = {}

#<> Optionally (for local testing), the contents of a chef admin's key (\n replaced with |)
default['site-chefcitypo3org']['knife_client_key'] = nil

#<> URL of the main chef repo
default['site-chefcitypo3org']['main_repo'] = "ssh://chef-jenkins@review.typo3.org:29418/Teams/Server/Chef.git"

#<> Github OAuth client ID
default['site-chefcitypo3org']['auth']['github_client_id'] = nil

#<> Github OAuth client secret
default['site-chefcitypo3org']['auth']['github_client_secret'] = nil
