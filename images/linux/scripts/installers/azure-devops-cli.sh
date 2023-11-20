#!/bin/bash -e
################################################################################
##  File:  azure-devops-cli.sh
##  Desc:  Installed Azure DevOps CLI (az devops)
################################################################################

# AZURE_EXTENSION_DIR shell variable defines where modules are installed
# https://docs.microsoft.com/en-us/cli/azure/azure-cli-extensions-overview
export AZURE_EXTENSION_DIR=/opt/az/azcliextensions
echo "AZURE_EXTENSION_DIR=$AZURE_EXTENSION_DIR" | tee -a /etc/environment

# install azure devops Cli extension
extensions=$(az extension list-available --query "[?preview == \`false\` && experimental == \`false\` && name != \`azure-cli-ml\`].{name:name}" -o json )
items=$(echo "$extensions" | jq -c -r '.[]')
for item in ${items[@]}; do name=$(jq '.name' <<< "$item" | tr -d '"'); az extension add --upgrade --name "$name"; done
az aks install-cli

#invoke_tests "CLI.Tools" "Azure DevOps CLI"