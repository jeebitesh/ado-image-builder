#!/bin/bash -e
################################################################################
##  File:  owasp-dependencey-check.sh
##  Desc:  Installed OWASP Depedencey Check (az)
################################################################################
source "$HELPER_SCRIPTS"/install.sh
# Install OWASP Depedencey Check
URL='https://owasp.org/www-project-dependency-check/'
HTML=$( curl -# -L "${URL}" 2> '/dev/null' )
TEMP=$(TAG='p'; grep --only-matching '<'$TAG'>Version.*</'$TAG'>' <(echo "$HTML") | sed 's/\(<'$TAG'>\|<\/'$TAG'>\)//g' | tr " " " ")
VERSION=$(read -a arr <<< "$TEMP"; echo "${arr[1]}")
ZIP_NAME="dependency-check-${VERSION}-release"
ZIP_URL="https://github.com/jeremylong/DependencyCheck/releases/download/v${VERSION}/${ZIP_NAME}.zip"
download_with_retries "${ZIP_URL}" "/tmp" "${ZIP_NAME}.zip"
unzip -qq "/tmp/${ZIP_NAME}.zip" -d /usr/share
ln -s /usr/share/"${ZIP_NAME}"/bin/dependency-check.sh /usr/bin/dependency-check.sh
ln -s /usr/share/"${ZIP_NAME}"/bin/completion-for-dependency-check.sh /usr/bin/completion-for-dependency-check.sh
rm -f "/tmp/${ZIP_NAME}.zip"