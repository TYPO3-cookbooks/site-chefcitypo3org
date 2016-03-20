=begin
#<
Installs basic packages on the machine
#>
=end

# TODO as of 2016-03-20 this installs Vagrant 1.6.5
# TODO find out how to install a more recent version on Debian
%w(git vim vagrant).each do | package_name |
	package package_name do
		action :install
	end
end
