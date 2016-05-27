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
  # because without updated plugins, it fails at the first start
  # ignore_failure true
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
cookbook_org_job = File.join(Chef::Config[:file_cache_path], "TYPO3-cookbooks.xml")

template cookbook_org_job do
  source "jenkins-jobs/github-organization-folder/TYPO3-cookbooks.xml.erb"
  notifies  :create, "jenkins_job[TYPO3-cookbooks]", :immediately
end

jenkins_job "TYPO3-cookbooks" do
  action :nothing
  config cookbook_org_job
  # as our plugins aren't up to date, building this job fails until they're updated
  ignore_failure true
end

# token of the chefcitypo3org user
jenkins_password_credentials node['site-chefcitypo3org']['auth']['github_user'] do
  id "github-chefcitypo3org-token"
  password node['site-chefcitypo3org']['auth']['github_token'] || "nothing-given"
  description "Github API token"
end
