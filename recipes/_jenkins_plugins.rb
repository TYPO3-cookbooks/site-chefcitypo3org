=begin
#<
Installs Jenkins plugins
#>
=end

plugins = {
  "workflow-aggregator" => "2.1",
  "workflow-scm-step" => nil, # "2.0",
  "workflow-support" => nil, # "2.0",
  "workflow-cps" => nil, # "2.2",
  "workflow-job" => nil, # "2.1",
  "workflow-step-api" => nil, # "2.0",
  "pipeline-stage-step" => nil, # "2.1",
  "pipeline-stage-view" => nil, # "1.3",
  "script-security" => "1.19",
  "job-dsl" => nil,
  "git" => "2.4.4", # version installed by default is too old for pipeline
  "github" => nil,
  # "ghprb" => nil,
  "clone-workspace-scm" => nil,
  "warnings" => nil,
  "analysis-collector" => nil,
  "ansicolor" => nil,
  "greenballs" => nil,
  "slack" => nil,
}

plugins.each do | plugin, plugin_version |
  jenkins_plugin plugin do
    version version if plugin_version
    notifies :execute, "jenkins_command[safe-restart]"
  end
end

jenkins_plugin "github-oauth" do
  notifies :execute, "jenkins_command[safe-restart]", :immediately
end

cookbook_file "#{node['jenkins']['master']['home']}/hudson.plugins.warnings.WarningsPublisher.xml" do
  owner "jenkins"
  group "jenkins"
  mode "0644"
  notifies :execute, "jenkins_command[reload-configuration]"
end