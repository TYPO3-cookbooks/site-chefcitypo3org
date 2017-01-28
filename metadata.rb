name             'site-chefcitypo3org'
maintainer       'TYPO3 Server Admin Team'
maintainer_email 'adminATtypo3DOTorg'
license          'Apache 2.0'
description      'Provisions a Chef CI/CD server based on Jenkins.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.0.1'

supports         'debian'

depends          't3-base', '~> 0.2.0'
depends          't3-chef-vault', '~> 1.0.0'
depends          'jenkins-chefci'# , '~> 1.0.0'

# Make sure to freeze all versions of community cookbooks here!
depends          'java',              '= 1.46.0'
depends          'jenkins',           '= 4.2.1'
depends          'ssh_known_hosts',   '= 2.0.0'
depends          'chef-dk',           '= 3.1.0'

# pinned in t3-base
depends          'sudo'
depends          'apt'
depends          'git'
