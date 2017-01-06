=begin
#<
Defines the Jenkins jobs
#>
=end

#######################
# JobDSL Seed
#######################
chef_repo_jobdsl_job = File.join(Chef::Config[:file_cache_path], "chef_repo_seed.xml")

template chef_repo_jobdsl_job do
  source "jenkins-jobs/jobdsl/chef_repo.xml.erb"
  notifies  :create, "jenkins_job[chef-repo-seed]", :immediately
  notifies  :build, "jenkins_job[chef-repo-seed]"
end

jenkins_job "chef-repo-seed" do
  action :nothing
  config chef_repo_jobdsl_job
end

directory "#{node['jenkins']['master']['home']}/jobs/chef-repo-seed/workspace/" do
  action :create
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  mode      '0755'
end

template "#{node['jenkins']['master']['home']}/jobs/chef-repo-seed/workspace/chef_repo.groovy" do
  source "jenkins-jobs/jobdsl/chef_repo.groovy.erb"
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  notifies  :build, "jenkins_job[chef-repo-seed]"
end

#######################
# Github Organization TYPO3-cookbooks
#######################
cookbook_org_job_name = node['site-chefcitypo3org']['github_org']
cookbook_org_job = File.join(Chef::Config[:file_cache_path], "github-org-#{cookbook_org_job_name}.xml")

template cookbook_org_job do
  source "jenkins-jobs/github-organization-folder/TYPO3-cookbooks.xml.erb"
  notifies :create, "jenkins_job[#{cookbook_org_job_name}]", :immediately
end

jenkins_job cookbook_org_job_name do
  action :nothing
  config cookbook_org_job
end

# token of the chefcitypo3org user
github_chefcitypo3org_user = node['site-chefcitypo3org']['auth']['github_user']
github_chefcitypo3org_token = node['site-chefcitypo3org']['auth']['github_token']

include_recipe "t3-chef-vault"
begin
  github_chefcitypo3org_user ||= chef_vault_password("github.com", "chefcitypo3org", "username")
rescue
  Chef::Log.warn "Also could not read github username from chef-vault"
end

begin
  github_chefcitypo3org_token ||= chef_vault_password("github.com", "chefcitypo3org", "token")
rescue
  Chef::Log.warn "Also could not read github token from chef-vault"
end

if github_chefcitypo3org_token
  jenkins_password_credentials github_chefcitypo3org_user do
    id "github-chefcitypo3org-token"
    password github_chefcitypo3org_token
    description "Github API token"
  end
end

#######################
# Workflow Global Library
#######################

jenkins_script 'global-library-chefci' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.Jenkins
    import org.jenkinsci.plugins.workflow.libs.SCMSourceRetriever;
    import org.jenkinsci.plugins.workflow.libs.LibraryConfiguration;
    import jenkins.plugins.git.GitSCMSource;

    SCMSourceRetriever retriever = new SCMSourceRetriever(new GitSCMSource(
        "global-library-chefci",
        "https://github.com/TYPO3-infrastructure/jenkins-pipeline-global-library-chefci/",
        null,
        "*",
        "",
        false))
    LibraryConfiguration pipeline = new LibraryConfiguration("chefci", retriever)
    pipeline.setDefaultVersion('master')
    pipeline.setImplicit(true)

    Jenkins.getInstance().getDescriptor("org.jenkinsci.plugins.workflow.libs.GlobalLibraries").get()
        .setLibraries([pipeline])
  EOH
end
