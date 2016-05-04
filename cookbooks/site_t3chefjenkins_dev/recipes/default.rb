=begin
#<
Wires together all the pieces
#>
=end

%w(apt git java).each do | recipe |
  include_recipe recipe
end

%w(_packages _jenkins_setup _chefdk _jenkins_plugins _jenkins_auth _jenkins_jobs _docker _misc).each do | local_recipe |
  include_recipe "site_t3chefjenkins_dev::#{local_recipe}"
end

include_recipe 'chef-zero'
