#!/bin/bash

# Delete all namespaces except system namespaces
for ns in $(kubectl get namespaces -o json | jq -r '.items[] | select(.metadata.name != "kube-system" and .metadata.name != "kube-public" and .metadata.name != "default") | .metadata.name'); do
    kubectl delete namespace $ns
done

echo "Cluster cleanup completed."
