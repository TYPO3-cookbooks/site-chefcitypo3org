# Finally, install jenkins
include_recipe "jenkins::master"

# LTS version
#r = resources("apt_repository[jenkins]")
#r.uri 'http://pkg.jenkins-ci.org/debian-stable'
#r.key 'http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key'

jenkins_command 'safe-restart' do
  action :nothing
end

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

# Jenkins.instance.setNumExecutors(4)

