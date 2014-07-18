#
# Cookbook Name:: mount
# Recipe:: _glusterfs
#
# Copyright (C) 2013 UAF GINA
# 

case node['platform']
  when 'redhat', 'centos'
    glusterfs_package = "glusterfs-fuse"
  when 'ubuntu'
    glusterfs_package = "glusterfs-client"
end

unless glusterfs_package.nil?
  package glusterfs_package do
    action :install
  end
end
