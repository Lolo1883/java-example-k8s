#!/bin/bash

BACKUP_DIR="k8s-backup"

# Restore namespaces
for ns in $(jq -r '.metadata.name' $BACKUP_DIR/namespaces.json); do
    kubectl create namespace $ns
done

# Restore resources in each namespace
for ns in $(jq -r '.metadata.name' $BACKUP_DIR/namespaces.json); do
    for res in deployments services configmaps secrets statefulsets daemonsets replicasets ingress; do
        if [ -f $BACKUP_DIR/$ns/$res.yaml ]; then
            kubectl apply -f $BACKUP_DIR/$ns/$res.yaml
        fi
    done
done

echo "Cluster rebuild completed."
