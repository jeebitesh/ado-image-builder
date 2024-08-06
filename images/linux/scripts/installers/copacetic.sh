#!/bin/bash -e
################################################################################
##  File:  copacetic.sh
##  Desc:  Installs Docker Compose
################################################################################
copa.version: "0.7.0"
# Install docker-compose v1 from releases
URL="https://github.com/project-copacetic/copacetic/releases/download/v${copa_version}/copa_${copa_version}_linux_amd64.tar.gz"
curl -fsSL "$URL"
tar -C /usr/local/bin -zxvf copa_"${copa_version}"_*.tar.gz copa
chmod +x /usr/local/bin/copa


curl -fsSL --insecure https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash