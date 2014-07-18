#
# Cookbook Name:: mount
# Recipe:: _autofs
#
# Copyright (C) 2013 UAF GINA
# 

case node['platform']
  when 'redhat', 'centos'
    autofs_package = "autofs"
  when 'ubuntu'
    autofs_package = "autofs"
end

unless autofs_package.nil?
  package autofs_package do
    action :install
  end
 
  service autofs_package do
    action [:restart, :enable, :start]
  end
end
