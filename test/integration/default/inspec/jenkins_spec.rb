control 'jenkins-1' do
  title 'Jenkins Setup'
  desc '
    Check that jenkins is installed and listening to ports
  '
  describe package('jenkins') do
    it { should be_installed }
  end

  #describe service('jenkins') do
  #  it { should be_installed }
  #  it { should be_running }
  #end

  describe port(8080) do
    it { should be_listening }
    its('protocols') { should include 'tcp6'}
    its('processes') { should include 'java' }
  end
end
