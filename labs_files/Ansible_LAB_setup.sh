#!/bin/bash
sudo yum -y install epel-release
sudo yum -y install ansible

echo "
10.0.0.10 master
10.0.0.21 slave01
10.0.0.22 slave02
10.0.0.23 slave03
" >> /etc/hosts
