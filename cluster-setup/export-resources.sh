#!/bin/bash

BACKUP_DIR="k8s-backup"
mkdir -p $BACKUP_DIR

# Backup all namespaces except system namespaces
kubectl get namespaces -o json | jq '.items[] | select(.metadata.name != "kube-system" and .metadata.name != "kube-public" and .metadata.name != "default")' > $BACKUP_DIR/namespaces.json

# Backup resources in each namespace
for ns in $(jq -r '.metadata.name' $BACKUP_DIR/namespaces.json); do
    mkdir -p $BACKUP_DIR/$ns
    for res in deployments services configmaps secrets statefulsets daemonsets replicasets ingress; do
        kubectl get $res -n $ns -o yaml > $BACKUP_DIR/$ns/$res.yaml
    done
done

echo "Backup completed and saved in $BACKUP_DIR"

