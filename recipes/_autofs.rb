#
# Cookbook Name:: mount
# Recipe:: _autofs
#
# Copyright (C) 2013 UAF GINA
# 

case node['platform_family']
  when 'rhel'
    autofs_package = "autofs"
  when 'ubuntu'
    autofs_package = "autofs"
end

package autofs_package do
  action :install
end

service autofs_package do
  action [:enable, :start]
end
