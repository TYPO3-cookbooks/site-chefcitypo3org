=begin
#<
Installs Jenkins plugins
#>
=end

%w(git workflow-aggregator job-dsl github build-pipeline-plugin clone-workspace-scm ghprb warnings ansicolor workflow-scm-step pipeline-stage-view).each do | plugin |
	jenkins_plugin plugin
end
