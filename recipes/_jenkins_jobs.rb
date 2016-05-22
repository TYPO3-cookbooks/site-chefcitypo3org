=begin
#<
Defines the Jenkins jobs
#>
=end

#######################
# JobDSL Seed
#######################
seed_chef_job_xml = File.join(Chef::Config[:file_cache_path], "seed-chef.xml")

template seed_chef_job_xml do
  source "jenkins-jobs/seed-chef/seed-chef.xml.erb"
  notifies  :create, "jenkins_job[seed-chef]", :immediately
  notifies  :build, "jenkins_job[seed-chef]"
end

jenkins_job "seed-chef" do
  action :nothing
  config seed_chef_job_xml
  # because without updated plugins, it fails at the first start
  ignore_failure true
end

# TODO - fix this, file might be overridden by git clone in the seed job
# TODO - so either remove the git cloning (which means, we have to run Chef every time this script changes)
# TODO - or make the seed job work with the file that is acutally checked out by git
directory "#{node['jenkins']['master']['home']}/jobs/seed-chef/workspace/" do
  action :create
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  mode      '0755'
end


template "#{node['jenkins']['master']['home']}/jobs/seed-chef/workspace/seed_jobdsl.groovy" do
  source "jenkins-jobs/seed-chef/seed_jobdsl.groovy.erb"
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  notifies  :build, "jenkins_job[seed-chef]"
end

#######################
# Github Organization TYPO3-cookbooks
#######################
cookbook_org_job_xml = File.join(Chef::Config[:file_cache_path], "TYPO3-cookbooks.xml")

template seed_chef_job_xml do
  source "jenkins-jobs/github-organization-folder/TYPO3-cookbooks.xml.erb"
  notifies  :create, "jenkins_job[TYPO3-cookbooks]", :immediately
  notifies  :build, "jenkins_job[TYPO3-cookbooks]"
end

jenkins_job "TYPO3-cookbooks" do
  action :nothing
  config cookbook_org_job_xml
end
