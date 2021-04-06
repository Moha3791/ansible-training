#!/bin/bash
sudo yum -y install epel-release
sudo yum -y install ansible

echo "
10.0.0.10 master
10.0.0.21 node01
10.0.0.22 node02
10.0.0.31 ubuntu01
10.0.0.32 ubuntu02
" >> /etc/hosts
