chef_dk 't3chefjenkins_chefdk' do
  version node['t3chefjenkins']['chefdk']['version']
  global_shell_init true
  action :install
end


if node['t3chefjenkins']['use_docker']
  %w{
  kitchen-docker
  }.each do |gem|
    gem_package gem do
      gem_binary "/opt/chefdk/embedded/bin/gem"
      options "--no-document --no-user-install"
    end
  end
end
