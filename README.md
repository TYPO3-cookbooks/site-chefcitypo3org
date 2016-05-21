# Description

Provisions a Jenkins master server.

# Requirements

## Platform:

* debian

## Cookbooks:

* t3-base (~> 0.2.0)
* java (= 1.39.0)
* jenkins (= 2.5.0)
* ssh_known_hosts (= 2.0.0)
* chef-dk (= 3.1.0)
* sudo
* apt
* git

# Attributes

* `node['site-chefcitypo3org']['url']` - Public URL of the Jenkins master. Defaults to `https://chef-ci.typo3.org`.
* `node['jenkins']['master']['repository']` - Install Jenkins LTS. Defaults to `http://pkg.jenkins-ci.org/debian-stable`.
* `node['java']['jdk_version']` - Sets the required Java version. Defaults to `7`.
* `node['java']['install_flavor']` - Sets the Java installation distribution. Defaults to `openjdk`.
* `node['jenkins']['master']['shell']` - Sets the default shell for the jenkins system user. Defaults to `/bin/bash`.
* `node['jenkins']['master']['plugins']` - Configures the Jenkins plugins to be installed on the server. Defaults to `{ ... }`.
* `node['site-chefcitypo3org']['chefdk']['version']` - Configures the ChefDK version to be installed - see https://github.com/chef/chef-dk. Defaults to `0.12.0-1`.
* `node['site-chefcitypo3org']['kitchen']['chef_version']` - Configures the version of Chef to use for test-kitchen runs. Defaults to `12.5.1`.
* `node['site-chefcitypo3org']['knife_config']` - The knife/chef configuration for communicating with the Chef API. Defaults to `{ ... }`.
* `node['site-chefcitypo3org']['knife_client_key']` - Optionally (for local testing), the contents of a chef admin's key (\n replaced with |). Defaults to `nil`.
* `node['site-chefcitypo3org']['main_repo']` - URL of the main chef repo. Defaults to `ssh://chef-jenkins@review.typo3.org:29418/Teams/Server/Chef.git`.
* `node['site-chefcitypo3org']['auth']['github_client_id']` - Github OAuth client ID. Defaults to `nil`.
* `node['site-chefcitypo3org']['auth']['github_client_secret']` - Github OAuth client secret. Defaults to `nil`.

# Recipes

* [site-chefcitypo3org::default](#site-chefcitypo3orgdefault)

## site-chefcitypo3org::default

Wires together all the pieces

Jenkins Infrastructure for TYPO3 Cookbook Testing
=================================================

This project contains a Chef repository for a Jenkins setup for testing the TYPO3 Chef Cookbooks from [https://github.com/TYPO3-cookbooks/](https://github.com/TYPO3-cookbooks/).



Vagrant Box for Development
===========================

The project contains a `Vagrantfile` that creates a Vagrant box for local development.



What's inside?
--------------

The Vagrant Box contains

* A chef-client for provisioning the box
* A Jenkins Server provisioned by Chef
* All the plugins that are required for running the Jenkins jobs in your virtual machine
* ChefDK
* VirtualBox
* Vagrant



Setup of the Vagrant Box
------------------------

Run the following commands to get started with the Vagrant Box:

    gem install bundler
    bundle install
    berks vendor -b cookbooks/site_t3chefjenkins_dev/Berksfile berks-cookbooks

Make sure to run the `berks` command above every time you changed the cookbook before you run `vagrant provision`

(TODO) describe how to set up ChefDK and only use TestKitchen (which is hopefully provided by ChefDK).



Usage of the Vagrant Box
------------------------

1. Clone this repository to some local directory
1. Run `vagrant up` to bring the machine up
1. Run `vagrant ssh` to ssh into the machine



Project Roadmap
===============

The following "epics" shall be achieved

1. (/) Installing all necessary Chef tools (ChefDK)
1. (/) Setting up a basic Jenkins Server
1. (/) Installing necessary plugins for seed jobs and the Jenkins pipeline plugin
1. (/) Configuring a seed job for the TYPO3 cookbooks (from Github)
1. Configuring a seed job for the TYPO3 Chef Repository (from Gerrit)
1. Run cookbook tests on Jenkins (ServerSpec and ChefSpec) using TestKitchen and Docker
1. Managing Jenkins jobs to push the cookbooks to the Chef Server



Jenkins Job Provisioning with Chef
----------------------------------

Our goal is to provision a Jenkins server that has a build pipeline for every Chef cookbook developed by the TYPO3 server team. The cookbooks can be found in this Github organization: [https://github.com/TYPO3-cookbooks/](https://github.com/TYPO3-cookbooks/). The rough sketch of the provisioning is as follows:

1. Chef provisions a Jenkins server with the [job-dsl plugin](https://wiki.jenkins-ci.org/display/JENKINS/Job+DSL+Plugin) and the [pipeline plugin](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Plugin)

1. Chef provisions a seed job (a job-dsl job) that

    1. uses the Github API to read all repositories from the TYPO3-cookbooks organization

    1. creates a [pipeline](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Plugin) job for each of these repositories

Afterwards we have a Jenkins server with a build pipeline for every cookbook in the TYPO3-cookbooks organization.



Open Issues
===========

* (/) The Jenkins jobs are build with Jobs DSL Plugin using "classic Jenkins jobs" - we should take a look at the [pipeline plugin](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Plugin) as this will keep the number of jobs smaller
* From time to time we get a `Jenkins::Helper::JenkinsNotReady` error when provisioning Jenkins. We then have to ssh into the machine and re-start Jenkins manually...
* (/) Jenkins is currently not started as a service - but that's what we want... see [https://github.com/TYPO3-infrastructure/chef-jenkins/commit/64367b4e00313c89824f1cc23a1a40f1d5a58f67]
* We get "out of limit warnings" from Github since we are currently using an unauthenticated API request. We should use API credentials to prevent this.
* Currently we do not handle cookbook upload to Chef Server
* Get rid of Vagrant and write documentation how to use Testkitchen
* Write some Unit / Integration tests
* Refactor `site_t3chefjenkins_dev` into `app_t3chefjenkins` and `site_t3chefjenkins_prod` for separating dev and prod environment
* Write cookbook doc and use `knife-cookbook-doc` to render cookbook README



Further Resources
=================

* Codecentric Blog Post [Using Jenkins Job DSL for Job Lifecycle Management](https://blog.codecentric.de/en/2015/10/using-jenkins-job-dsl-for-job-lifecycle-management/)
* [Jobs DSL Plugin on Github](https://github.com/jenkinsci/job-dsl-plugin/wiki)
* [Jobs DSL Documentation for seeding Workflow / Pipeline Jobs](https://jenkinsci.github.io/job-dsl-plugin/#path/workflowJob)
* [Jenkins Workflow / Pipeline plugin](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Plugin)



Authors
=======

* Steffen Gebert
* Andreas Wolf
* Michael Lihs




Manual Steps
------------

After chef provisioning, some manual steps have to be excecuted, in order to finalize the setup of the Chef CI.

### Plugin Updates

Update all Plugins, i.e., a newer version of the Github and Pipeline plugins are required.

### SSH Credentials for Gerrit

In order to let Jenkins connect to the main _chef-repo_ located in Gerrit, SSH credentials have to be added.

Replace the contents of `/var/lib/jenkins/.ssh/id_rsa` with the RSA private key.

### Chef User Credentials

In order to let Jenkins communicate with the Chef server API, a valid admin key has to be set up.

Place this private key into `/var/lib/jenkins/.chef/client.pem` (and validate the setup using `knife status` as `jenkins` user).

**Note:** When testing this cookbook within test-kitchen, the `.kitchen.yml` automatically tries to copy the user's private key into the VM.

### Github.com Credentials

* Go to _Manage Jenkins_ and _Configure System_.
* In the _GitHub_ section, add a new _GitHub Server_.
* Use the _Add_ button to add the credentials for the _chefcitypo3org_ user and convert it to a token
* Activate _Manage hooks_
* Under _Advanced_, hooks can be updated using the _Re-register hooks for all jobs_ - but only for jobs that already ran.

### Gerrit

* Place the private key of the typo3.org user that is registered in Gerrit in `/var/lib/jenkins/.ssh/id_rsa`.
* Go to _Manage Jenkins_ and _Gerrit Trigger_.
* Add `review.typo3.org` as a new server.

# License and Maintainer

Maintainer:: Michael Lihs (<mimi@kaktusteam.def>)

License:: All rights reserved
