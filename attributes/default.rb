#################
# Versions
#################

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

#<> Use this Github organization to read cookbooks from
default['jenkins_chefci']['github_organization'] = 'TYPO3-cookbooks'

#################
# Jenkins Plugins
#################

#<> List of plugins to install
# Plugins:
# Retrieve this list via Jenkins Script console:
#
# Jenkins.instance.pluginManager.plugins.sort().each{ plugin -> println ("${plugin.getShortName()}:${plugin.getVersion()}") }
#
# default['jenkins_chefci']['jenkins_plugins'] = %w{}
