# script to start all my lxc instances used for chef 

#!/bin/bash
sudo lxc-start -n chef-server1 -d
sudo lxc-start -n chef-workstation -d
sudo lxc-start -n chef-client -d
