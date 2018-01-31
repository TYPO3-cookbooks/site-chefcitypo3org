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

