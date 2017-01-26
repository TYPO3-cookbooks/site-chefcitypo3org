=begin
#<
Installs Jenkins plugins
#>
=end

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
