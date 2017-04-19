=begin
#<
Sets up Authentication
#>
=end

node.run_state[:github_oauth_client_id]     = node['site-chefcitypo3org']['auth']['github_client_id']
node.run_state[:github_oauth_client_secret] = node['site-chefcitypo3org']['auth']['github_client_secret']

include_recipe "t3-chef-vault"
begin
  node.run_state[:github_oauth_client_id] ||= chef_vault_password("github.com", "oauth", "client_id")
rescue
  Chef::Log.warn "Also could not read oauth client_id from chef-vault"
end

begin
  node.run_state[:github_oauth_client_secret] ||= chef_vault_password("github.com", "oauth", "client_secret")
rescue
  Chef::Log.warn "Also could not read oauth client_secret from chef-vault"
end

# This configures authentication
jenkins_script 'auth' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.Jenkins
    import hudson.security.SecurityRealm
    import hudson.security.GlobalMatrixAuthorizationStrategy
    import org.jenkinsci.plugins.GithubSecurityRealm
    def instance = Jenkins.getInstance()

    //////////////////////////////////////
    // Authentication (via Github)
    //////////////////////////////////////

    // We guard the security realm setup in a check that is based on the github_client_secret chef attribute.
    // In production, we manually configure this. In test-kitchen (see .kitchen.yml), we automatically confgure it through env vars.
    if ('#{node.run_state[:github_oauth_client_secret]}') {
      String githubWebUri = 'https://github.com'
      String githubApiUri = 'https://api.github.com'
      String clientID = '#{node.run_state[:github_oauth_client_id]}'
      String clientSecret = '#{node.run_state[:github_oauth_client_secret]}'
      String oauthScopes = 'read:org,user:email'
      SecurityRealm github_realm = new GithubSecurityRealm(githubWebUri, githubApiUri, clientID, clientSecret, oauthScopes)

      //check for equality, no need to modify the runtime if no settings changed
      if (!github_realm.equals(Jenkins.instance.getSecurityRealm())) {
        Jenkins.instance.setSecurityRealm(github_realm)
        Jenkins.instance.save()
      }

      //////////////////////////////////////
      // Authorization
      //////////////////////////////////////

      def strategy = new GlobalMatrixAuthorizationStrategy()
      strategy.add(Jenkins.ADMINISTER, "TYPO3-cookbooks")
      // strategy.add(Jenkins.ADMINISTER, "StephenKing")
      strategy.add(Jenkins.ADMINISTER, "#{resources('jenkins_user[chef]').id}")
      strategy.add(Jenkins.READ, "anonymous")
      strategy.add(hudson.model.Item.READ, "anonymous")
      strategy.add(hudson.model.View.READ, "anonymous")

      //check for equality, no need to modify the runtime if no settings changed
      if (!strategy.equals(Jenkins.instance.getAuthorizationStrategy())) {
        Jenkins.instance.setAuthorizationStrategy(strategy)
        Jenkins.instance.save()
      }
    }
  EOH
end


##################################
# Jenkins Job DSL Script Security
##################################
# This disables script security for the JobDSL plugin.
# Matters only, if authentication is configured in Jenkins.
# see https://github.com/jenkinsci/job-dsl-plugin/wiki/Script-Security

# no clue, why the jenkins script works in the script console, but not via Chef
# jenkins_script 'jobdsl-script-security' do
#   command <<-EOH.gsub(/^ {2}/, '')
#   import jenkins.model.Jenkins
#   import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration
#
#   Jenkins.getInstance().getDescriptorByType(GlobalJobDslSecurityConfiguration.class).useScriptSecurity = false
#   Jenkins.getInstance().save()
#
#   EOH
# end

# thus drop the resulting XML config
cookbook_file "#{node['jenkins']['master']['home']}/javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration.xml" do
  owner 'jenkins'
  group 'jenkins'
  mode 0644
  notifies :execute, 'jenkins_command[reload-configuration]'
end

# more secure: run as the user who triggered the build (using the authorize-project plugin)
# see https://github.com/jenkinsci/job-dsl-plugin/wiki/Script-Security
# somehow, this prevents other pipeline jobs to run
# jenkins_script 'jobdsl-auth' do
#   command <<-EOH.gsub(/^ {4}/, '')
#     import jenkins.security.*
#     import hudson.util.DescribableList
#     import org.jenkinsci.plugins.authorizeproject.*
#     import org.jenkinsci.plugins.authorizeproject.strategy.*
#
#     DescribableList<QueueItemAuthenticator, QueueItemAuthenticatorDescriptor> authenticators =
#       QueueItemAuthenticatorConfiguration.get().getAuthenticators();
#
#
#     if (authenticators.isEmpty()) {
#       println "Adding TriggeringUsersAuthorizationStrategy"
#       GlobalQueueItemAuthenticator triggerUserAuthenticator = new GlobalQueueItemAuthenticator(new TriggeringUsersAuthorizationStrategy())
#
#       authenticators.add(triggerUserAuthenticator)
#     } else {
#       println "AuthenticationStrategy already set"
#     }
#   EOH
# end
