ruby_block "fix-address-not-available" do
  block do
    file = Chef::Util::FileEdit.new("/etc/hosts")
    file.search_file_replace_line(/^::1.*/, "::1  ip6-localhost ip6-loopback")
    file.write_file
  end
end
