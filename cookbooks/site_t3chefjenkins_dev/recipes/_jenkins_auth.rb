require 'openssl'
require 'net/ssh'

if node['jenkins']['private_key']
  Chef::Log.info("Using existing private key for the chef user in jenkins")
  key = OpenSSL::PKey::RSA.new(node['jenkins']['private_key'])
else
  Chef::Log.info("Generating new key pair for the chef user in jenkins")
  key = OpenSSL::PKey::RSA.new(2048)
  IO.write(File.join("/tmp", "chef-jenkins.pem"), key.to_pem)
  node.set['jenkins']['private_key'] = key.to_pem
end

private_key = key.to_pem
public_key = "#{key.ssh_type} #{[key.to_blob].pack('m0')} auto-generated key"

# Create the Jenkins user with the public key
jenkins_user "chef" do
  id "chef@#{Chef::Config[:node_name]}"
  full_name "Chef"
  public_keys [public_key]
end

# Set the private key on the Jenkins executor
node.run_state[:jenkins_private_key] = private_key

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
    if ('#{node['t3chefjenkins']['auth']['github_client_secret']}') {
      String githubWebUri = 'https://github.com'
      String githubApiUri = 'https://api.github.com'
      String clientID = '#{node['t3chefjenkins']['auth']['github_client_id']}'
      String clientSecret = '#{node['t3chefjenkins']['auth']['github_client_secret']}'
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

jenkins_script 'github_authentication' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.SecurityRealm
    import org.jenkinsci.plugins.GithubSecurityRealm
    String githubWebUri = 'https://github.com'
    String githubApiUri = 'https://api.github.com'
    String clientID = 'fb64fbdf87f22091c50a'
    String clientSecret = 'FIXME_FIXME_FIXME_FIXME_FIXME_FIXME'
    String oauthScopes = 'read:org,user:email'
    SecurityRealm github_realm = new GithubSecurityRealm(githubWebUri, githubApiUri, clientID, clientSecret, oauthScopes)


    //check for equality, no need to modify the runtime if no settings changed
    if(!github_realm.equals(Jenkins.instance.getSecurityRealm())) {
      Jenkins.instance.setSecurityRealm(github_realm)
      Jenkins.instance.save()
    }
  EOH
  action :nothing
end

jenkins_script 'github_authentication' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import org.jenkinsci.plugins.GithubAuthorizationStrategy
    import hudson.security.AuthorizationStrategy

    //permissions are ordered similar to web UI
    //Admin User Names
    String adminUserNames = 'StephenKing'
    //Participant in Organization
    String organizationNames = 'TYPO3-cookbooks'
    //Use Github repository permissions
    boolean useRepositoryPermissions = true
    //Grant READ permissions to all Authenticated Users
    boolean authenticatedUserReadPermission = false
    //Grant CREATE Job permissions to all Authenticated Users
    boolean authenticatedUserCreateJobPermission = false
    //Grant READ permissions for /github-webhook
    boolean allowGithubWebHookPermission = true
    //Grant READ permissions for /cc.xml
    boolean allowCcTrayPermission = true
    //Grant READ permissions for Anonymous Users
    boolean allowAnonymousReadPermission = true
    //Grant ViewStatus permissions for Anonymous Users
    boolean allowAnonymousJobStatusPermission = true

    AuthorizationStrategy github_authorization = new GithubAuthorizationStrategy(adminUserNames,
                                                                                 authenticatedUserReadPermission,
                                                                                 useRepositoryPermissions,
                                                                                 authenticatedUserCreateJobPermission,
                                                                                 organizationNames,
                                                                                 allowGithubWebHookPermission,
                                                                                 allowCcTrayPermission,
                                                                                 allowAnonymousReadPermission,
                                                                                 allowAnonymousJobStatusPermission)

    //check for equality, no need to modify the runtime if no settings changed
    if(!github_authorization.equals(Jenkins.instance.getAuthorizationStrategy())) {
      Jenkins.instance.setAuthorizationStrategy(github_authorization)
      Jenkins.instance.save()
    }
  EOH
  action :nothing
end