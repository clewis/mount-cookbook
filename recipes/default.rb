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

Array(node['mounts']['directories']).each do |d|
  directory d[:name] do
    if d.has_key?( :owner)
      owner l[:owner]
    else
      owner "root"
    end
    if d.has_key?( :group)
      group d[:group]
    else
      group node[:root_group]
    end
    if d.has_key?( :mode)
      mode d[:mode]
    else
      mode 0755
    end

    if d.has_key?( :action) 
      action d[:action]
    end
  end
end 

Array(node['mounts']['links']).each do |l|
  link l[:dest] do
    to l[:src]

    if l.has_key?( :owner)
      owner l[:owner]
    else
      owner "root"
    end
    if l.has_key?( :group)
      group l[:group]
    else
      group node[:root_group]
    end
    if l.has_key?( :mode)
      mode l[:mode]
    else
      mode 0777
    end

    if l.has_key?( :action) 
      action l[:action]
    end
    if l.has_key?( :type) 
      link_type l[:type]
    end
  end
end 

Array(node['mounts']['glob_links']).each do |gl|
  directory( gl[:dest_directory]) do
    if gl.has_key?( :owner)
      owner gl[:owner]
    else
      owner "root"
    end
    if gl.has_key?( :group)
      group gl[:group]
    else
      group node[:root_group]
    end
    if gl.has_key?( :mode)
      mode gl[:mode]
    else
      mode 0755
    end
  end

  Dir.glob( gl[:src_pattern]).each do |src_path|
    src_filename = File::basename( src_path)
    dest_path = File.join( gl[:dest_directory], src_filename)
   
    link dest_path do
      to src_path

      if gl.has_key?( :owner)
        owner gl[:owner]
      else
        owner "root"
      end
      if gl.has_key?( :group)
        group gl[:group]
      else
        group node[:root_group]
      end
      if gl.has_key?( :mode)
        mode gl[:mode]
      else
        mode 0777
      end

      if gl.has_key?( :action) 
        action gl[:action]
      end
      if gl.has_key?( :type) 
        link_type gl[:type]
      end
    end
  end
end 


