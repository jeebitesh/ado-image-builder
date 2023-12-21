#!/bin/bash -e
################################################################################
##  File:  trivy.sh
##  Desc:  Installs Aqua Trivy
##  Url:   https://aquasecurity.github.io/trivy/v0.48/getting-started/installation/
################################################################################

source "$HELPER_SCRIPTS"/install.sh

apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
apt-get update
apt-get install trivy -y