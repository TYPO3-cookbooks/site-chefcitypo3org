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
  - Parallelized execution of test-kitchen tests on different nodes

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

Manual Steps
------------

After chef provisioning, some manual steps have to be excecuted, in order to finalize the setup of the Chef CI.

### Plugin Updates

Update all Plugins, i.e., a newer version of the Github and Pipeline plugins are required.

### Gerrit Credentials and Trigger

* In order to let Jenkins connect to the main _chef-repo_ located in Gerrit, SSH credentials have to be added.
Replace the contents of `/var/lib/jenkins/.ssh/id_rsa` with the RSA private key.

* In order to trigger Jenkins, once a change is pushed, set up the _Gerrit Trigger_:
  - Go to _Manage Jenkins_ and _Gerrit Trigger_.
  - Add `review.typo3.org` as a new server.

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

License:: Apache 2.0
