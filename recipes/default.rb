#
# Cookbook Name:: mount
# Recipe:: default
#
# Copyright (C) 2013 UAF GINA
# 

include_recipe "mount::_nfs"
include_recipe "mount::_autofs"
include_recipe "mount::_glusterfs"

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

# Setup Autofs mounts
Array(node['mounts']['auto']).each do |a|
  directory a['parent_directory'] do
    recursive true
    action :create
  end
  if a.has_key?("REMOVE")
    if File.exists?(a['config_file'])
      fe = Chef::Util::FileEdit.new(a['config_file'])
      fe.search_file_delete_line(/#{a['device']}/)
      fe.write_file
    end
  else
    if File.exists?("/etc/auto.master")
      fe = Chef::Util::FileEdit.new("/etc/auto.master")
      fe.insert_line_if_no_match(/^#{a['parent_directory']}\s+/,"#{a['parent_directory']}	#{a['config_file']}	--timeout=60 --ghost\n")
      fe.search_file_replace(/^\+/, "#+")
      fe.write_file
    else
      file "/etc/auto.master" do
        owner "root"
        group "root"
        mode 0664
        content "#{a['parent_directory']}  #{a['config_file']}     --timeout=60 --ghost"
        action :create_if_missing
      end
    end
    if File.exists?(a['config_file'])
      fe = Chef::Util::FileEdit.new(a['config_file'])
      fe.insert_line_if_no_match(/#\s+{a['device']}$/,"#{a['mount_point']}	-fstype=#{a['fstype']},#{a['options']}	#{a['device']}\n")
      fe.write_file
    else
      file a['config_file'] do
        owner "root"
        group "root"
        mode 0664
        content "#{a['mount_point']}    -fstype=#{a['fstype']},#{a['options']}    #{a['device']}\n"
        action :create_if_missing
      end
    end
  end
end

