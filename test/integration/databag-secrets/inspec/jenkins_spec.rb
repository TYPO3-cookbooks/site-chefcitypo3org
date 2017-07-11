control 'jenkins-1' do
  title 'Jenkins Setup'
  desc 'Check that jenkins is installed and listening to ports'

  # describe package('jenkins') do
  #   it { should be_installed }
  # end

  #describe service('jenkins') do
  #  it { should be_installed }
  #  it { should be_running }
  #end

  describe port(8080) do
    it { should be_listening }
    # its('protocols') { should include 'tcp6' }
    # its('processes') { should include 'java' }
  end
end

control 'jenkins-2' do
  title 'Jenkins No-Auth'
  desc 'Check that Jenkins has no auth configured'

  xml_parse_options = {
    assignment_re: %r{^\s*<([^>]*?)>(.*?)<\/[^>]*>\s*$}
  }

  describe parse_config_file('/var/lib/jenkins/config.xml', xml_parse_options) do
    its('useSecurity') { should eq 'true' }
  end
end
