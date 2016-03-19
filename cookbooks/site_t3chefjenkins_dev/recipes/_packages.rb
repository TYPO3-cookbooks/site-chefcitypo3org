=begin
#<
Installs basic packages on the machine
#>
=end


%w(git vim).each do | package_name |
	package 'git' do
		action :install
	end
end
