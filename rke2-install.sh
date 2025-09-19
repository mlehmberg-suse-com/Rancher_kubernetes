#!/bin/bash
#curl -sfL https://get.rke2.io --output install.sh
#chmod +x install.sh
#sleep 10
INSTALL_RKE2_TYPE=server \
INSTALL_RKE2_CHANNEL=v1.24 \
./install.sh
mkdir -p /etc/rancher/rke2
echo create the config.yaml 
#cp config-multus.yaml /etc/rancher/rke2/config.yaml
#sleep 10
#systemctl enable --now rke2-server.service 
