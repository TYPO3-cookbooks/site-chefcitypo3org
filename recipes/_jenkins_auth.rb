=begin
#<
Sets up Authentication
#>
=end

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
