#!/bin/bash -e
################################################################################
##  File:  powershellcore.sh
##  Desc:  Installs powershellcore
################################################################################

source "$HELPER_SCRIPTS"/install.sh
###################################
# Prerequisites

# Update the list of packages
apt-get update

# Install pre-requisite packages.
apt-get install -y install wget ca-certificates curl apt-transport-https software-properties-common lsb-release gnupg

# Get the version of Ubuntu
source /etc/os-release

# Download the Microsoft repository keys
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"

# Register the Microsoft repository keys
dpkg -i packages-microsoft-prod.deb

# Delete the the Microsoft repository keys file
rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com
apt-get update

# Install Powershell
apt-get install -y powershell
