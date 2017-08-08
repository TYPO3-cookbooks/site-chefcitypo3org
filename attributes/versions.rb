#<> Configures the ChefDK version to be installed - see https://github.com/chef/chef-dk
default['jenkins_chefci']['chefdk_version'] = '1.0.3-1'

#<> Configures the version of Chef to use for test-kitchen runs
default['jenkins_chefci']['kitchen']['chef_version'] = '12.21.3'
