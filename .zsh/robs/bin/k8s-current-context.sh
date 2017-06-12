#!/usr/bin/env bash
set -euo pipefail

current_context_file=~/.k8s-current-context
current_context=$(kubectl config current-context)

project=$(echo ${current_context} | cut -d_ -f2)
zone=$(echo ${current_context} | cut -d_ -f3)
cluster=$(echo ${current_context} | cut -d_ -f4)

cat << EOF > ${current_context_file}.new
K8S_CURRENT_CONTEXT_PROJECT=${project}
K8S_CURRENT_CONTEXT_ZONE=${zone}
K8S_CURRENT_CONTEXT_CLUSTER=${cluster}
EOF

mv -v ${current_context_file}.new ${current_context_file}
