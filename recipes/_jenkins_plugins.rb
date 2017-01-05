=begin
#<
Installs Jenkins plugins
#>
=end

# Retrieve this list via Jenkins Script console:
#
# Jenkins.instance.pluginManager.plugins.sort().each{ plugin -> println ("${plugin.getShortName()}:${plugin.getVersion()}") }

plugins = %w{
ace-editor:1.1
analysis-collector:1.49
analysis-core:1.81
ansicolor:0.4.3
ant:1.4
antisamy-markup-formatter:1.5
bouncycastle-api:2.16.0
branch-api:1.11.1
buildtriggerbadge:2.7
clone-workspace-scm:0.6
cloudbees-folder:5.15
credentials:2.1.10
display-url-api:0.5
durable-task:1.12
embeddable-build-status:1.9
external-monitor-job:1.6
gerrit-trigger:2.23.0
git:3.0.1
git-client:2.1.0
git-server:1.7
github:1.25.0
github-api:1.82
github-branch-source:1.10.1
github-oauth:0.25
github-organization-folder:1.5
greenballs:1.15
handlebars:1.1.1
icon-shim:2.0.3
javadoc:1.4
job-dsl:1.53
jquery-detached:1.2.1
junit:1.19
ldap:1.13
mailer:1.18
matrix-auth:1.4
matrix-project:1.7.1
maven-plugin:2.14
momentjs:1.1.1
pam-auth:1.3
pipeline-build-step:2.4
pipeline-graph-analysis:1.3
pipeline-input-step:2.5
pipeline-milestone-step:1.2
pipeline-rest-api:2.4
pipeline-stage-step:2.2
pipeline-stage-view:2.4
piwikanalytics:1.2.0
plain-credentials:1.3
PrioritySorter:3.4.1
scm-api:1.3
script-security:1.24
slack:2.1
ssh-credentials:1.12
structs:1.5
token-macro:2.0
warnings:4.58
windows-slaves:1.2
workflow-aggregator:2.4
workflow-api:2.8
workflow-basic-steps:2.3
workflow-cps:2.23
workflow-cps-global-lib:2.5
workflow-durable-task-step:2.5
workflow-job:2.9
workflow-multibranch:2.9.2
workflow-scm-step:2.3
workflow-step-api:2.6
workflow-support:2.11
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
