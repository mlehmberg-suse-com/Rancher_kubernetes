#!/bin/bash

# this will stop and remove rke2
# Make copy of YAML file incase we ever need it 
cp /etc/rancher/rke2/config.yaml ~/
#stop RKE services 
systemctl disable --now rke2-agent.service 
systemctl disable --now rke2-server.service 
sleep 10

rke2-killall.sh 
sleep 10
rke2-uninstall.sh
sleep 10 
rm /etc/sysctl.d/60-rke2-cis.conf 
userdel etcd
groupdel etcd 
