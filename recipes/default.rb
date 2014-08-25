#
# Cookbook Name:: mount
# Recipe:: default
#
# Copyright (C) 2013 UAF GINA
# 

include_recipe "mount::_nfs"

# Setup Static mounts: create mountpoints and configure in fstab
Array(node['mounts']['static']).each do |s|
  if s.has_key?("REMOVE")
    mount s['mount_point'] do
      ignore_failure true
      action :umount
    end
    directory s['mount_point'] do
      ignore_failure true
      action :delete
    end
    mount s['mount_point'] do
      ignore_failure true
      action :disable
    end
  else
    directory s['mount_point'] do
      recursive true
      action :create
    end
    mount s['mount_point'] do
      device s['device']
      device_type s['device_type']
      fstype s['fstype']
      mount_point s['mount_point']
      options s['options']
      dump s['dump']
      pass s['pass']
      action [:mount, :enable]
    end
  end
end

