=begin
#<
Provides a Jenkins master server.
#>
=end

%w(apt git vagrant java jenkins::master).each do | recipe |
	include_recipe recipe
end

%w(_packages _virtualbox _chefdk _jenkins_plugins _jenkins_jobs).each do | local_recipe |
	include_recipe "site_t3chefjenkins_dev::#{local_recipe}"
end

include_recipe 'chef-zero'

jenkins_command 'safe-restart'
