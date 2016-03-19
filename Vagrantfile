=begin
 Vagrantfile for provisioning a Jenkins servier for TYPO3 Cookbook testing.

 Copyright 2016, Michael Lihs

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

=end

# FQDN for the Vagrant box
$hostname = 't3chefjenkins.dev.localhost'

# The path inside the Vagrant box where the Vagrant directory is mounted
$vagrant_mount_path = '/var/vagrant'

# The script that's run in the Vagrant box for provisioning the box
$inline_script = <<-EOSCRIPT
    command -v curl >/dev/null 2>&1 || sudo yum -y install curl
    command -v chef-client >/dev/null 2>&1 || curl -s  -L https://www.chef.io/chef/install.sh | sudo bash
    chef-client -v | grep -q ' 12\.' || curl -s -L https://www.chef.io/chef/install.sh | sudo bash
    sudo hostname #{$hostname}
    sudo /usr/bin/chef-client -z -o 'recipe[site_t3chefjenkins_dev]' -c #{$vagrant_mount_path}/solo.rb -F doc
EOSCRIPT



Vagrant.configure('2') do |config|
  config.vm.define :chef_jenkins do |chef_jenkins|

    # Box setup
    chef_jenkins.vm.box = 'debian/jessie64'

    # VM settings
    chef_jenkins.vm.provider 'virtualbox' do |v|
      v.name = 'TYPO3-Chef-Jenkins'
      v.customize [
                    'modifyvm', :id,
                    '--memory', 2048,
                    '--cpus', 1
                  ]
    end

    # Disable default synced folder
    chef_jenkins.vm.synced_folder '.', '/vagrant', id: 'vagrant-root', disabled: true
    chef_jenkins.vm.synced_folder '.', $vagrant_mount_path, :nfs => true, :nfs_version => 3

    # Network settings
    chef_jenkins.vm.hostname = $hostname
    chef_jenkins.vm.network :private_network, ip: '10.20.30.40', netmask: '255.255.255.0'

    # SSH settings
    chef_jenkins.ssh.forward_agent = true

    # Run provisioning of chef server box using chef-solo
    chef_jenkins.vm.provision :shell do |s|
      s.inline = $inline_script
    end

  end
end
