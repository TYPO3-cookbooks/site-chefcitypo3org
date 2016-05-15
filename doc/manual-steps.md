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
 