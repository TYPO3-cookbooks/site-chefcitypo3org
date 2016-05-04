# Description

Provisions a Jenkins master server.

# Requirements

## Platform:

* debian

## Cookbooks:

* java (~> 1.35.0)
* jenkins (= 2.4.1)
* ssh_known_hosts (~> 2.0.0)
* vagrant (~> 0.5.0)
* git
* chef-zero
* chef-dk
* docker
* apt-docker
* sudo
* apt

# Attributes

* `node['jenkins']['master']['endpoint']` - URL of this Jenkins instance. Defaults to `https://chef-ci.typo3.org`.
* `node['jenkins']['master']['repository']` - Install Jenkins LTS. Defaults to `http://pkg.jenkins-ci.org/debian-stable`.
* `node['java']['jdk_version']` - Sets the required Java version. Defaults to `7`.
* `node['java']['install_flavor']` - Sets the Java installation distribution. Defaults to `openjdk`.
* `node['jenkins']['master']['shell']` - Sets the default shell for the jenkins system user. Defaults to `/bin/bash`.
* `node['jenkins']['master']['plugins']` - Configures the Jenkins plugins to be installed on the server. Defaults to `{ ... }`.
* `node['t3chefjenkins']['chefdk']['version']` - Configures the ChefDK version to be installed - see https://github.com/chef/chef-dk. Defaults to `0.12.0-1`.
* `node['t3chefjenkins']['kitchen']['chef_version']` - Configures the version of Chef to use for test-kitchen runs. Defaults to `12.5.1`.
* `node['t3chefjenkins']['use_docker']` - Optionally disable usage of Docker. Defaults to `true`.
* `node['t3chefjenkins']['knife_config']` - The knife/chef configuration for communicating with the Chef API. Defaults to `{ ... }`.
* `node['t3chefjenkins']['knife_client_key']` - Optionally (for local testing), the contents of a chef admin's key (\n replaced with |). Defaults to `nil`.
* `node['t3chefjenkins']['main_repo']` - URL of the main chef repo. Defaults to `ssh://chef-jenkins@review.typo3.org:29418/Teams/Server/Chef.git`.
* `node['t3chefjenkins']['auth']['github_client_id']` - Github OAuth client ID. Defaults to `nil`.
* `node['t3chefjenkins']['auth']['github_client_secret']` - Github OAuth client secret. Defaults to `nil`.

# Recipes

* [site_t3chefjenkins_dev::default](#site_t3chefjenkins_devdefault)

## site_t3chefjenkins_dev::default

Wires together all the pieces



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

* TODO

### Manually Run Seed Job

 As of version 2.4.1 of the [jenkins](https://supermarket.chef.io/cookbooks/jenkins) cookbook, the latest changes in _master_ to add the `:build` action to the `jenkins_job` resource have not been released, yet.
 Therefore, manually run the _Job DSL seed job_, which creates all other jobs.


# License and Maintainer

Maintainer:: Michael Lihs (<mimi@kaktusteam.def>)

License:: All rights reserved
