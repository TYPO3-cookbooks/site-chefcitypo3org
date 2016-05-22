Testing (isolated from TYPO3)
----------------

This cookbook is tailored to the needs at [TYPO3](https://typo3.org).

In order to let give it a try without credentials to our Chef server, you have to adjust the following pices:

* `Berksfile`: remove line `source 'http://chef.typo3.org:26200'`
* `metadata.rb`: remove line `depends 't3-base', '~> 0.2.0'`
* `recipes/default.rb`: remove line `include_recipe "t3-base"`
