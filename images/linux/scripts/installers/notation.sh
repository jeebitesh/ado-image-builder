#!/bin/bash -e
################################################################################
##  File:  nvm.sh
##  Desc:  Installs Nvm
################################################################################

source "$HELPER_SCRIPTS"/install.sh

version=$(get_toolset_value ".notation.version")


# Download, extract and install
curl -Lo notation.tar.gz https://github.com/notaryproject/notation/releases/download/v${version}/notation_${version}_linux_amd64.tar.gz
tar xvzf notation.tar.gz

# Copy the notation cli to the desired bin directory in your PATH, for example
cp ./notation /usr/local/bin

rm notation.tar.gz

## install akv plugin
notation plugin install --url https://github.com/Azure/notation-azure-kv/releases/download/${version}/notation-azure-kv_${version}_linux_amd64.tar.gz --sha256sum 06bb5198af31ce11b08c4557ae4c2cbfb09878dfa6b637b7407ebc2d57b87b34