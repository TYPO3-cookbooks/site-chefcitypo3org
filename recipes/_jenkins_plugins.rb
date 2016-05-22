=begin
#<
Installs Jenkins plugins
#>
=end

# we really need a version newer than 2.2.x and I don't know why, but below
# code does not install the new version.
jenkins_plugin "git" do
  source "https://updates.jenkins-ci.org/download/plugins/git/2.4.4/git.hpi"
end

plugins = [
  "workflow-aggregator",
  "workflow-scm-step",
  "workflow-support",
  "workflow-cps",
  "workflow-job",
  "workflow-step-api",
  "pipeline-stage-step",
  "pipeline-stage-view",
  "script-security",
  "job-dsl",
  # "git" => "2.4.4", # version installed by default is too old for pipeline
  "github",
  "gerrit-trigger",
  "clone-workspace-scm",
  "warnings",
  "analysis-collector",
  "ansicolor",
  "greenballs",
  "slack",
]

plugins.each_with_index do | plugin, index |
  jenkins_plugin plugin do
    notifies :execute, "jenkins_command[safe-restart]", :immediately if index == plugins.length - 1
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