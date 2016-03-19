Jenkins Infrastructure for TYPO3 Cookbook Testing
=================================================

This project contains a Jenkins setup for testing the TYPO3 Chef Cookbooks from [https://github.com/TYPO3-cookbooks/](https://github.com/TYPO3-cookbooks/).



Vagrant Box for Development
===========================

The project contains a `Vagrantfile` that creates a Vagrant box for local development.


What's inside?
--------------

The Vagrant Box contains

* A chef-client for provisioning the box
* A Jenkins Server provisioned by Chef
* All the plugins that are required for running the Jenkins jobs in your virtual machine



Setup of the Vagrant Box
------------------------

Run the following commands to get started with the Vagrant Box:


    gem install bundler
    bundle install
    berks vendor -b cookbooks/site_t3chefjenkins_dev/Berksfile berks-cookbooks


Make sure to run the `berks` command above every time you changed the cookbook before you run `vagrant provision`


Usage of the Vagrant Box
------------------------

1. Clone this repository to some local directory
1. Run `vagrant up` to bring the machine up
1. Run `vagrant ssh` to ssh into the machine



Project Roadmap
===============

The following "epics" shall be achieved

1. Installing all necessary Chef tools (ChefDK)
1. Setting up a basic Jenkins Server
1. Installing necessary plugins for seed jobs and the Jenkins pipeline plugin
1. Configuring a seed job for the TYPO3 cookbooks (from Github)
1. Configuring a seed job for the TYPO3 Chef Repository (from Gerrit)
1. Managing Jenkins jobs to push the cookbooks to the Chef Server



Jenkins Job Provisioning with Chef
----------------------------------

Our goal is to provision a Jenkins server that has a build pipeline for every Chef cookbook developed by the TYPO3 server team. The cookbooks can be found in this Github organization: [https://github.com/TYPO3-cookbooks/](https://github.com/TYPO3-cookbooks/). The rough sketch of the provisioning is as follows:

1. Chef provisions a Jenkins server with the [job-dsl plugin](https://wiki.jenkins-ci.org/display/JENKINS/Job+DSL+Plugin) and the [pipeline plugin](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Plugin)

1. Chef provisions a seed job (a job-dsl job) that

    1. uses the Github API to read all repositories from the TYPO3-cookbooks organization

    1. creates a pipeline job for each of these repositories

Afterwards we have a Jenkins server with a build pipeline for every cookbook in the TYPO3-cookbooks organization.



Authors
=======

* Steffen Gebert 
* Andreas Wolf
* Michael Lihs
