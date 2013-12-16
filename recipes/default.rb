#
# Cookbook Name:: mount
# Recipe:: default
#
# Copyright (C) 2013 UAF GINA
# 

include_recipe "mount::_nfs"
include_recipe "mount::_autofs"

node['mounts']['static'].each do |stat|
  directory stat['mount_point'] do
      action :create
  end
  mount stat['mount_point'] do
    device stat['device']
    device_type stat['device_type']
    fstype stat['fstype']
    mount_point stat['mount_point']
    options stat['options']
    dump stat['dump']
    pass stat['pass']
    action [:mount, :enable]
  end
end
node['mounts']['auto'].each do |auto|
  directory auto['parent_directory'] do
    recursive true
    action :create
  end
  fe = Chef::Util::FileEdit.new("/etc/auto.master")
  fe.insert_line_if_no_match(/^#{auto['parent_directory']}/,"#{auto['parent_directory']}	#{auto['config_file']}	--timeout=60 --ghost\n")
  fe.search_file_replace(/^\+/, "#+")
  fe.write_file
  if File.exists?(auto['config_file']) 
    fe = Chef::Util::FileEdit.new(auto['config_file'])
    fe.insert_line_if_no_match(/#{auto['device']}/,"#{auto['mount_point']}	-fstype=#{auto['fstype']},#{auto['options']}	#{auto['device']}\n")
    fe.write_file
  else
    file auto['config_file'] do
      owner "root"
      group "root"
      mode 0664
      content "#{auto['mount_point']}    -fstype=#{auto['fstype']},#{auto['options']}    #{auto['device']}"
      action :create_if_missing
    end
  end
end
