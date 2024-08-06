#!/bin/bash -e
################################################################################
##  File:  kubescape.sh
##  Desc:  Installs kubescape
################################################################################

sudo add-apt-repository ppa:kubescape/kubescape
sudo apt update
sudo apt install kubescape