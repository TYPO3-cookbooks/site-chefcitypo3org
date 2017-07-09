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

directory "#{node['jenkins']['master']['home']}/workspace/chef-repo-seed/" do
  action :create
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  mode      '0755'
  recursive true
end

template "#{node['jenkins']['master']['home']}/workspace/chef-repo-seed/chef_repo.groovy" do
  source "jenkins-jobs/jobdsl/chef_repo.groovy.erb"
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  notifies  :build, "jenkins_job[chef-repo-seed]"
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
