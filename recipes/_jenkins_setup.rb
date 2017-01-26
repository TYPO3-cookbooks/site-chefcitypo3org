=begin
#<
Install and configure Jenkins
#>
=end

jenkins_command 'reload-configuration' do
  action :nothing
end

jenkins_script 'jenkins-location-configuration' do
  command <<-EOH.gsub(/^ {4}/, '')
  import jenkins.model.*

  def jlc = JenkinsLocationConfiguration.get()
  jlc.setAdminAddress("TYPO3 Server Admin Team <admin@typo3.org>")
  jlc.setUrl("#{node['site-chefcitypo3org']['url']}")
  jlc.save()

  EOH
end
