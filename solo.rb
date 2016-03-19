# -*- mode: ruby -*-
# vi: set ft=ruby :

# This is required to provision the vagrant box with chef solo

current_dir = File.dirname(__FILE__)

file_cache_path '/tmp/chef-cache'
cookbook_path ["#{current_dir}/berks-cookbooks"]
data_bag_path "#{current_dir}/databags"
ssl_verify_mode :verify_none
