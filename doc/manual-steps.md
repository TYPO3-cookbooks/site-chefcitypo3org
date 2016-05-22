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
