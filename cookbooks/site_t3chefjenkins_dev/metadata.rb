name             'site_t3chefjenkins_dev'
maintainer       'Michael Lihs'
maintainer_email 'mimi@kaktusteam.def'
license          'All rights reserved'
description      'Provisions a Jenkins master server.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports         'debian'

# Make sure to freeze all versions of community cookbooks here!
depends          'java',              '~> 1.35.0'
depends          'jenkins',           '~> 2.3.0'
depends          'apt'
depends          'ssh_known_hosts',   '~> 2.0.0'
depends          'sudo',              '~> 2.7.0'
depends          'vagrant',           '~> 0.5.0'
depends          'git'
depends          'chef-zero'
depends          'chef-dk'

depends          'docker'
depends          'apt-docker'
