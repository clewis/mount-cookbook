#
# Cookbook Name:: mount
# Recipe:: _nfs
#
# Copyright (C) 2013 UAF GINA
# 

case node['platform']
  when 'redhat', 'centos'
    nfs_package = "nfs-utils"
  when 'ubuntu'
    nfs_package = "nfs-common"
end

unless nfs_package.nil?
  package nfs_package do
    action :install
  end
end
