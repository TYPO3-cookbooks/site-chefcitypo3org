#################
# Versions
#################

#<> Configures the ChefDK version to be installed - see https://github.com/chef/chef-dk
default['site-chefcitypo3org']['chefdk']['version'] = "0.12.0-1"

#<> Configures the version of Chef to use for test-kitchen runs
default['site-chefcitypo3org']['kitchen']['chef_version'] = "12.5.1"

#################
# URLs
#################

#<> Public URL of the Jenkins master
default['site-chefcitypo3org']['url'] = "https://chef-ci.typo3.org"

#<> URL of the main chef repo
default['site-chefcitypo3org']['main_repo'] = "ssh://chef-jenkins@review.typo3.org:29418/Teams/Server/Chef.git"

#<> Install Jenkins LTS
default['jenkins']['master']['repository'] = "http://pkg.jenkins-ci.org/debian-stable"
