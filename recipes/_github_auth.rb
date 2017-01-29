
#######################
# Github Credentials
#######################

include_recipe "t3-chef-vault"

begin
  node.run_state[:jenkins_chefci_github_login] = chef_vault_password('github.com', 'chefcitypo3org', 'username')
rescue
  Chef::Log.warn 'Could not read github username from chef-vault'
end

begin
  node.run_state[:jenkins_chefci_github_token] = chef_vault_password('github.com', 'chefcitypo3org', 'token')
rescue
  Chef::Log.warn 'Could not read github token from chef-vault'
end
