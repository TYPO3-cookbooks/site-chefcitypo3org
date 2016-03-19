=begin
#<
Provides a Jenkins master server.
#>
=end

include_recipe 'site_t3chefjenkins_dev::_packages'
include_recipe 'java'
include_recipe 'jenkins::master'

include_recipe 'site_t3chefjenkins_dev::_jenkins_plugins'
include_recipe 'site_t3chefjenkins_dev::_jenkins_jobs'

jenkins_command 'safe-restart'
