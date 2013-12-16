#
# Cookbook Name:: mount
# Recipe:: _nfs
#
# Copyright (C) 2013 UAF GINA
# 

case node['platform_family']
  when 'rhel'
    nfs_package = "nfs-utils"
  when 'ubuntu'
    nfs_package = "nfs-client"
end

package nfs_package do
  action :install
end
