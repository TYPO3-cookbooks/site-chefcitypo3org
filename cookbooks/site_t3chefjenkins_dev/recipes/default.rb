=begin
#<
Provides a Jenkins master server.
#>
=end

include_recipe 'apt'
include_recipe 'git'
include_recipe 'java'
include_recipe 'jenkins::master'

=begin
include_recipe 'site_t3chefjenkins_dev::_packages'
include_recipe 'site_t3chefjenkins_dev::_virtualbox'
include_recipe 'site_t3chefjenkins_dev::_chefdk'
include_recipe 'site_t3chefjenkins_dev::_jenkins_plugins'
include_recipe 'site_t3chefjenkins_dev::_jenkins_jobs'
=end

%w(_packages _virtualbox _chefdk _jenkins_plugins _jenkins_jobs).each do | local_recipe |
	include_recipe "site_t3chefjenkins_dev::#{local_recipe}"
end

include_recipe 'chef-zero'

jenkins_command 'safe-restart'
