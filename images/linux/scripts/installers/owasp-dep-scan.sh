#!/bin/bash -e
################################################################################
##  File:  owasp-dep-scan.sh
##  Desc:  Installed OWASP Dep-scan 
################################################################################
source "$HELPER_SCRIPTS"/install.sh

DEPSCAN_URL="https://github.com/appthreat/depscan-bin/releases/latest/download/depscan-linux-amd64"
download_with_retries "$DEPSCAN_URL" "/usr/bin" "depscan-linux-amd64"
chmod +x /usr/bin/depscan-linux-amd64