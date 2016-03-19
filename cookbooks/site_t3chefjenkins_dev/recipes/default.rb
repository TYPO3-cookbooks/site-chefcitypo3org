=begin
#<
Provides a Jenkins master server.
#>
=end

include_recipe 'java'
include_recipe 'jenkins::master'

%w(git workflow-aggregator job-dsl).each do | plugin |
	jenkins_plugin plugin
end