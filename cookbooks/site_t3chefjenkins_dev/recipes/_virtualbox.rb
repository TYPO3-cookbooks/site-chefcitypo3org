=begin
#<
Provides VirtualBox on Debian 8 "Jessie"
#>
=end	


# taken from https://wiki.debian.org/VirtualBox
apt_repository 'contrib' do
  uri        'http://httpredir.debian.org/debian/'
  components ['jessie main', 'contrib']
end

architecture = `uname -r|sed 's,[^-]*-[^-]*-,,'`


# TODO we somehow should pin the version of VirtualBox here...
package "linux-headers-#{architecture}"
package 'virtualbox'
