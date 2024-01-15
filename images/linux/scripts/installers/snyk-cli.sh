#!/bin/bash -e
################################################################################
##  File:  snyk-cli.sh
##  Desc:  Installs Snyk Cli
################################################################################

# Source the helpers for use with the script
source "$HELPER_SCRIPTS"/install.sh

VERSION=$(curl -fssL https://static.snyk.io/cli/latest/release.json | jq -r '.version | match("[0-9.]+").string')
SNYK_URL="https://static.snyk.io/cli/v${VERSION}/snyk-linux"
download_with_retries "$SNYK_URL" "/usr/bin" "snyk-linux"
chmod +x /usr/bin/snyk-linux