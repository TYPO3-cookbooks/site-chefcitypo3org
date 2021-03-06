=begin
#<
Wires together all the pieces
#>
=end

include_recipe "t3-base"

%w(apt git java).each do |recipe|
  include_recipe recipe
end

%w(_github_auth).each do |local_recipe|
  include_recipe "::#{local_recipe}"
end


include_recipe 'jenkins-chefci::full'

%w(_packages _jenkins_setup _jenkins_plugins _jenkins_auth _jenkins_jobs _ssh).each do |local_recipe|
  include_recipe "::#{local_recipe}"
end
