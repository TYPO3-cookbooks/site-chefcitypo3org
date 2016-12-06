control 'jenkins-3' do
  title 'Jenkins GitHub OAuth'
  desc 'Check that Jenkins has authentication configured'
  describe package('jenkins') do
    it { should be_installed }
  end

  xml_parse_options = {
    assignment_re: %r{^\s*<([^>]*?)>(.*?)<\/[^>]*>\s*$}
  }

  describe parse_config_file('/var/lib/jenkins/config.xml', xml_parse_options) do
    its('useSecurity') { should eq 'true' }
  end

  # verify that security is correctly applied
  describe command('curl --retry 10 --head http://localhost:8080/manage') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '403 Forbidden' }
  end

  # login redirects to GitHub OAuth login
  describe command('curl --retry 10 --head http://localhost:8080/securityRealm/commenceLogin') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include 'Location: https://github.com/login/oauth/authorize' }
  end
end
