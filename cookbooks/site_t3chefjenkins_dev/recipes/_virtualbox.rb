=begin
#<
Installs VirtualBox.

The version of VirtualBox is taken from the `node['virtualbox']['version']` attribute.
#>
=end

apt_repository 'oracle-virtualbox' do
  uri 'http://download.virtualbox.org/virtualbox/debian'
  key 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc'
  distribution 'trusty'
  components ['contrib']
end

package "virtualbox-#{node['virtualbox']['version']}" do
  action :install
end

# What is the 'dkms' package? http://askubuntu.com/questions/408605/what-does-dkms-do-how-do-i-use-it
package 'dkms' do
  action :install
end

