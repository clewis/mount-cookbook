# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "mount-berkshelf"

  config.vm.define 'ubuntu-13.04' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "opscode-ubuntu-13.04"
    c.vm.box_url = "http://goo.gl/Y4aRr"
    #c.vm.box_url = "http://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"
  end

  config.vm.define 'ubuntu-13.10' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "canonical-ubuntu-13.10"
    c.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box"
  end

  config.vm.define 'centos-6' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "opscode-centos-6.3"
    #c.vm.box_url = "http://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-6.3_chef-11.2.0.box"
    c.vm.box_url = "http://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-6.4_chef-11.4.4.box"
  end

  config.omnibus.chef_version = "11.6.0"
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = "./Berksfile"
  config.ssh.forward_agent = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mounts => {
        :auto => [
          {
            :device => 'pod6.gina.alaska.edu:/gvolfile',
            :fstype => 'nfs',
            :mount_point => 'OfficeShare',
            :options => 'rw,intr,tcp,nolock,vers=3',
            :parent_directory => '/auto/nfs',
            :config_file => '/etc/auto.nfs',
          }
        ],
        :static => [
          {
            :REMOVE => 'the value does not matter it will be removed if the REMOVE key is present',
            :device => 'pod6.gina.alaska.edu:/gvolfile',
            :fstype => 'nfs',
            :mount_point => '/static/nfs/OfficeShare',
            :options => 'intr,tcp,nolock,vers=3',
            :device_type => :device,
            :dump => 0,
            :pass => 2
          }
        ]
      }
    }

    chef.run_list = [
        "recipe[minitest-handler::default]",
        "recipe[mount::default]"
    ]
  end
end
