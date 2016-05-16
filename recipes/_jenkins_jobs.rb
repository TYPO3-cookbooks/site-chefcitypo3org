#
# Cookbook Name:: cooking-with-jenkins
# Recipe:: define-jenkins-jobs
#
# Adds jobs in Jenkins for testing our cookbooks
#
# Copyright (C) 2013 Zachary Stevens
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

seed_chef_job_xml = File.join(Chef::Config[:file_cache_path], "seed-chef.xml")

template seed_chef_job_xml do
  source "jenkins-jobs/seed-chef/seed-chef.xml.erb"
  notifies  :create, "jenkins_job[seed-chef]", :immediately
  notifies  :build, "jenkins_job[seed-chef]"
end

jenkins_job "seed-chef" do
  action :nothing
  config seed_chef_job_xml
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

