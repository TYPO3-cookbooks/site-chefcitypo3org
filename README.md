# Description

This project contains the Chef setup for a Jenkins-based CI/CD server for Chef cookbooks from [https://github.com/TYPO3-cookbooks/](https://github.com/TYPO3-cookbooks/).

## Contents

* Jenkins Setup
  - Install Jenkins LTS
  - Install Plugins
* Job Configuration
  - Seed job to generate the following (based on JobDSL)
  - Main _chef-repo_ job to validate and upload data bags, environments and roles
  - Multiple cookbook pipelines for cookbook testing and upload
* Feature Highlights
  - Fully automated job setup using JobDSL and Pipeline
  - Integration with Gerrit (for private main _chef-repo_) and Github (for cookbooks)
  - Parallelized execution of test-kitchen tests on different nodes

# Requirements

## Platform:

* debian

## Cookbooks:

* t3-base (~> 0.2.0)
* t3-chef-vault (~> 1.0.0)
* jenkins-chefci (~> 0.2.0)
* java (= 1.50.0)
* jenkins (= 5.0.2)
* ssh_known_hosts (= 2.0.0)
* chef-dk (= 3.1.0)
* sudo
* apt
* git
* #<Logger:0x00007fb7bfb4a298> () (Recommended but not required)
* #<Logger:0x00007fb7bfb4a298> () (Suggested but not required)
* Conflicts with #<Logger:0x00007fb7bfb4a298> ()

# Attributes

* `node['site-chefcitypo3org']['url']` - Public URL of the Jenkins master. Defaults to `https://chef-ci.typo3.org`.
* `node['site-chefcitypo3org']['main_repo']` - URL of the main chef repo. Defaults to `ssh://chef-jenkins@review.typo3.org:29418/Teams/Server/Chef.git`.
* `node['jenkins_chefci']['knife_config']['chef_server_url']` - URL of the CHef Server. Defaults to `https://chef.typo3.org`.
* `node['jenkins']['master']['repository']` - Install Jenkins LTS. Defaults to `http://pkg.jenkins-ci.org/debian-stable`.
* `node['jenkins_chefci']['github_organization']` - Use this Github organization to read cookbooks from. Defaults to `TYPO3-cookbooks`.
* `node['jenkins']['master']['jvm_options']` -  Defaults to `-Djenkins.install.runSetupWizard=false -XX:MaxPermSize=256m`.
* `node['java']['oracle']['accept_oracle_download_terms']` - Okay, Oracle, we hate you. Defaults to `true`.
* `node['jenkins_chefci']['jenkins_plugins']` -  Defaults to `%w(`.
* `node['site-chefcitypo3org']['auth']['github_client_id']` - Github OAuth client ID. Defaults to `nil`.
* `node['site-chefcitypo3org']['auth']['github_client_secret']` - Github OAuth client secret. Defaults to `nil`.
* `node['jenkins_chefci']['chefdk_version']` - Configures the ChefDK version to be installed - see https://github.com/chef/chef-dk. Defaults to `1.0.3-1`.
* `node['jenkins_chefci']['kitchen']['chef_version']` - Configures the version of Chef to use for test-kitchen runs. Defaults to `12.21.3`.

# Recipes

* [site-chefcitypo3org::default](#site-chefcitypo3orgdefault)

## site-chefcitypo3org::default

Wires together all the pieces

Application Data
----------------

Application data resides in `/var/lib/jenkins`.

Section [Manual Steps](#manual-steps) describes setup of keys.

To migrate job history, copy over `/var/lib/jenkins/jobs/` to the new server.


Build Status
------------

Build status on our [CI server](https://chef-ci.typo3.org):

- *master* (release): [![Build Status master branch](https://chef-ci.typo3.org/job/TYPO3-cookbooks/job/site-chefcitypo3org/branch/master/badge/icon)](https://chef-ci.typo3.org/job/TYPO3-cookbooks/job/site-chefcitypo3org/branch/master/)
- *develop* (next release): [![Build Status develop branch](https://chef-ci.typo3.org/job/TYPO3-cookbooks/job/site-chefcitypo3org/branch/develop/badge/icon)](https://chef-ci.typo3.org/job/TYPO3-cookbooks/job/site-chefcitypo3org/branch/develop/)


knife vault create passwords-production githubcom-oauth -S "recipe:site-chefcitypo3org" -J test/integration/databag-secrets/data_bags/REAL_DO_NOT_COMMIT_passwords-_default/githubcom-oauth.json
knife vault create passwords-production githubcom-chefcitypo3org -S "recipe:site-chefcitypo3org" -J test/integration/databag-secrets/data_bags/REAL_DO_NOT_COMMIT_passwords-_default/githubcom-chefcitypo3org.json


Manual Steps
------------

After chef provisioning, some manual steps have to be excecuted, in order to finalize the setup of the Chef CI.

### Slack Setup

- build fails first with `NullPointerException` --> save config once to have a working Jenkins (for testing)
- Configure the API token for both (?) config sections:
  * _Slack Webhook Settings_:
    - _Outgoing Webhook Token_: _fill in_
    - _Outgoing Webhook URL Endpoint_: `slackwebhook`
  * _Global Slack Notifier Settings_:
    - _Team Subdomain_: `typo3`
    - _Integration Token_: _fill in_

### Gerrit Credentials and Trigger

* In order to let Jenkins connect to the main _chef-repo_ located in Gerrit, SSH credentials have to be added.
Replace the contents of `/var/lib/jenkins/.ssh/id_rsa` with the RSA private key.

* In order to trigger Jenkins, once a change is pushed, set up the _Gerrit Trigger_:
  - Go to _Manage Jenkins_ and _Gerrit Trigger_.
  - Add `review.typo3.org` as a new server.
    * _Name_: `review.typo3.org`
    * _Hostname_: `review.typo3.org`
    * _Frontend URL_: `https://review.typo3.org/`
    * _Username_: `chef-jenkins`
    * _E-mail_: `admin@typo3.org`
    * _SSH Keyfile_: `/var/lib/jenkins/.ssh/id_rsa`
  - After saving, click the red _Status_ icon to establish the connection

### Chef User Credentials

In order to let Jenkins communicate with the Chef server API, a valid admin key has to be set up.

Replace the contents of `/var/lib/jenkins/.chef/client.pem` with the private key (and validate the setup using `knife status` as `jenkins` user).

**Note:** When testing this cookbook within test-kitchen, the `.kitchen.yml` automatically tries to copy the user's private key into the VM.



Testing (isolated from TYPO3)
----------------

This cookbook is tailored to the needs at [TYPO3](https://typo3.org).

In order to let give it a try without credentials to our Chef server, you have to adjust the following pices:

* `Berksfile`: remove line `source 'http://chef.typo3.org:26200'`
* `metadata.rb`: remove line `depends 't3-base', '~> 0.2.0'`
* `recipes/default.rb`: remove line `include_recipe "t3-base"`


TODOs
-----

[/] Use `github-organization-folder` plugin to scan for `Jenkinsfiles` in all repos.
[/] Use slaves to keep the master clean.
[/] Better highlight the error case (instead of requiring to scan through 2MB logs)


# License and Maintainer

Maintainer:: TYPO3 Server Admin Team (<adminATtypo3DOTorg>)

Source:: https://github.com/typo3-cookbooks/site-chefcitypo3org

Issues:: https://github.com/typo3-cookbooks/site-chefcitypo3org/issues

License:: Apache 2.0
