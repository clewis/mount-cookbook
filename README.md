# mount cookbook
Chef cookbook that uses attributes to manage static nfs/glusterfs mounts as well as autofs mounts for CentOS and Ubuntu

# Requirements
RHEL/CentOS or ubuntu

# Usage
Use attributes in role json files to add/remove fstab and/or autofs mounts
device_type is :device, :uuid, or :label
Add a REMOVE key to the anonymous hash to remove a mountpoint - the value does not matter
```
{
  "name": "YOUR_ROLE_NAME",
  "description": "YOUR_ROLE_DESCRIPTION",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mounts": {
      "auto": [
        {
          "device": "gluster.example.com:/volume1",
          "fstype": "glusterfs",
          "mount_point": "volume1",
          "options": "",
          "parent_directory": "/auto/glusterfs",
          "config_file": "/etc/auto.glusterfs"
        },
      ],
      "static": [
        {
          "device": "nfs.example.org:/volume2"
          "device_type": ":device"
          "fstype": "nfs"
          "mount_point": "/mounts/volume2"
          "options": "ro"
          "dump": "0"
          "pass": "0"

        }
      ] 
    }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[mount]"
  ],
  "env_run_lists": {
  }
}
```
# Recipes
mount::default
mount::_nfs
mount::_autofs
mount::_glusterfs

# Author
Author:: Mark Morlino (<mark@gina.alaska.edu>)
