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

##################################
# Jenkins Job DSL Script Security
##################################
# this would disable script security for the JobDSL plugin
# see https://github.com/jenkinsci/job-dsl-plugin/wiki/Script-Security
# jenkins_script 'jobdsl-script-security' do
#   command <<-EOH.gsub(/^ {2}/, '')
#   import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration
#
#   Jenkins.getInstance().getDescriptorByType(GlobalJobDslSecurityConfiguration.class).useScriptSecurity = false
#
#   EOH
# end
#
# more secure: run as the user who triggered the build (using the authorize-project plugin)
# see https://github.com/jenkinsci/job-dsl-plugin/wiki/Script-Security
jenkins_script 'jobdsl-auth' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.security.*
    import hudson.util.DescribableList
    import org.jenkinsci.plugins.authorizeproject.*
    import org.jenkinsci.plugins.authorizeproject.strategy.*
    
    DescribableList<QueueItemAuthenticator, QueueItemAuthenticatorDescriptor> authenticators =
      QueueItemAuthenticatorConfiguration.get().getAuthenticators();
    
    
    if (authenticators.isEmpty()) {
      println "Adding TriggeringUsersAuthorizationStrategy"
      GlobalQueueItemAuthenticator triggerUserAuthenticator = new GlobalQueueItemAuthenticator(new TriggeringUsersAuthorizationStrategy())
    
      authenticators.add(triggerUserAuthenticator)
    } else {
      println "AuthenticationStrategy already set"
    }
  EOH
end
