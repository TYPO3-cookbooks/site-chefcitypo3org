# These attributes are used by .kitchen.yml to ease local development of this cookbook

#<> The knife/chef configuration for communicating with the Chef API
default['site-chefcitypo3org']['knife_config'] = {}

#<> Optionally (for local testing), the contents of a chef admin's key (\n replaced with |)
default['site-chefcitypo3org']['knife_client_key'] = nil

#<> Github OAuth client ID
default['site-chefcitypo3org']['auth']['github_client_id'] = nil

#<> Github OAuth client secret
default['site-chefcitypo3org']['auth']['github_client_secret'] = nil

#<> Github Username
default['site-chefcitypo3org']['auth']['github_user'] = "chefcitypo3org"

#<> Github Token
default['site-chefcitypo3org']['auth']['github_token'] = nil
