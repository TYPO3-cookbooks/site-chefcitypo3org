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
2. Run `vagrant up` to bring the machine up
3. Run `vagrant ssh` to ssh into the machine



Project Roadmap
===============

The following "epics" shall be achieved

1. Setting up a basic Jenkins Server
2. Installing necessary plugins for seed jobs and the Jenkins pipeline plugin
3. Configuring a seed job for the TYPO3 cookbooks (from Github)
4. Configuring a seed job for the TYPO3 Chef Repository (from Gerrit)
5. Managing Jenkins jobs to push the cookbooks to the Chef Server



Authors
=======

* Steffen Gebert 
* Andreas Wolf
* Michael Lihs
