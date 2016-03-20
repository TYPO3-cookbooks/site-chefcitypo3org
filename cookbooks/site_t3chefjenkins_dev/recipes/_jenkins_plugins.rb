=begin
#<
Installs Jenkins plugins
#>
=end

%w(git workflow-aggregator job-dsl github build-pipeline-plugin clone-workspace-scm ghprb warnings ansicolor workflow-scm-step).each do | plugin |
	jenkins_plugin plugin
end
