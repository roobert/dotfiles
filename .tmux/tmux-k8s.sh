#!/usr/bin/env bash

if [[ ! -f ~/.kube/config ]]; then
  exit 0
fi

current_context_data="$(grep current-context ~/.kube/config | tr '_' ' ')"
project=$(echo $current_context_data | awk '{ print $3 }')
zone=$(echo $current_context_data | awk '{ print $4 }')
cluster=$(echo $current_context_data | awk '{ print $5 }')

echo "k8s:${project}/${cluster} •"
