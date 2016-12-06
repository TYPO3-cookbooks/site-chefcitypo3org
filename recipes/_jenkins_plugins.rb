=begin
#<
Installs Jenkins plugins
#>
=end

# Retrieve this list via Jenkins Script console:
#
# Jenkins.instance.pluginManager.plugins.each{
#   plugin ->
#   println ("${plugin.getShortName()}:${plugin.getVersion()}")
# }

plugins = %w{
cloudbees-folder:5.13
workflow-step-api:2.5
github-api:1.80
pipeline-graph-analysis:1.3
greenballs:1.15
antisamy-markup-formatter:1.5
git:3.0.1
workflow-scm-step:2.3
display-url-api:0.5
pipeline-rest-api:2.4
workflow-durable-task-step:2.5
github:1.24.0
workflow-job:2.9
workflow-basic-steps:2.3
structs:1.5
ace-editor:1.1
analysis-collector:1.49
pipeline-stage-step:2.2
ansicolor:0.4.3
pipeline-milestone-step:1.2
momentjs:1.1.1
external-monitor-job:1.6
pam-auth:1.3
ant:1.4
credentials:2.1.10
durable-task:1.12
pipeline-stage-view:2.4
ldap:1.13
icon-shim:2.0.3
maven-plugin:2.14
scm-api:1.3
github-branch-source:1.10.1
mailer:1.18
jquery-detached:1.2.1
javadoc:1.4
github-oauth:0.25
gerrit-trigger:2.23.0
piwikanalytics:1.2.0
branch-api:1.11.1
PrioritySorter:3.4.1
plain-credentials:1.3
workflow-api:2.8
github-organization-folder:1.5
workflow-aggregator:2.4
workflow-cps-global-lib:2.5
git-client:2.1.0
job-dsl:1.53
bouncycastle-api:2.16.0
analysis-core:1.81
token-macro:2.0
handlebars:1.1.1
slack:2.1
embeddable-build-status:1.9
clone-workspace-scm:0.6
pipeline-input-step:2.5
workflow-cps:2.23
workflow-multibranch:2.9.2
warnings:4.58
junit:1.19
git-server:1.7
workflow-support:2.11
ssh-credentials:1.12
matrix-auth:1.4
script-security:1.24
matrix-project:1.7.1
pipeline-build-step:2.4
windows-slaves:1.2
}

plugins.each_with_index do |plugin_with_version, index|
  plugin, version = plugin_with_version.split(':')
  jenkins_plugin plugin do
    version version
    install_deps false
    # we want to restart Jenkins after the last plugin installation
    notifies :execute, "jenkins_command[safe-restart]", :immediately if index == plugins.length - 1
  end
end

cookbook_file "#{node['jenkins']['master']['home']}/hudson.plugins.warnings.WarningsPublisher.xml" do
  owner "jenkins"
  group "jenkins"
  mode "0644"
  notifies :execute, "jenkins_command[reload-configuration]"
end

jenkins_script 'piwik-plugin-configuration' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*

    def inst = Jenkins.getInstance()
    def desc = inst.getDescriptor("hudson.plugins.piwik.PiwikAnalyticsPageDecorator")

    desc.setSiteId("34")
    desc.setPiwikServer("piwik.typo3.org/");
    desc.setPiwikPath("/");
    // desc.setAdditionnalDownloadExtensions(additionnalDEx);
    desc.setForceHttps(true);

    desc.save()
  EOH
end
