=begin
#<
Installs Jenkins plugins
#>
=end


plugins = [
  "matrix-auth",
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
  "git",
  "github",
  "github-oauth",
  "github-organization-folder",
  "gerrit-trigger",
  "clone-workspace-scm",
  "warnings",
  "analysis-collector",
  "ansicolor",
  "greenballs",
  "slack",
  "PrioritySorter",
  "embeddable-build-status",
  "piwikanalytics",
]

plugins.each_with_index do | plugin, index |
  jenkins_plugin plugin do
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
