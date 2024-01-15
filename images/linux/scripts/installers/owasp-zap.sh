#!/bin/bash -e
################################################################################
##  File:  owasp-zap.sh
##  Desc:  Installed OWASP ZAP
################################################################################
source "$HELPER_SCRIPTS"/install.sh

VERSION=$(curl -fssL https://api.github.com/repos/zaproxy/zaproxy/releases/latest | jq -r '.tag_name | match("[0-9.]+").string')
TARBALL_NAME="ZAP_${VERSION}_Linux.tar.gz"
TARBALL_URL="https://github.com/zaproxy/zaproxy/releases/download/v${VERSION}/${TARBALL_NAME}"
download_with_retries "${TARBALL_URL}" "/tmp" "${TARBALL_NAME}"
tar xzf "/tmp/${TARBALL_NAME}"
mv "/tmp/ZAP_${VERSION}_Linux" /usr/share/zap
ln -s /usr/share/zap/bin/zap.sh /usr/bin/zap.sh
rm -f "/tmp/${TARBALL_NAME}"