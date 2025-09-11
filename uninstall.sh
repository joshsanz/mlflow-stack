#!/bin/bash
set -e

echo "=== 🧹 Uninstalling Bitnami Helm Charts ==="
microk8s helm3 uninstall mlflow --namespace mlflow || echo "MLflow not found"
microk8s helm3 uninstall minio --namespace minio || echo "MinIO not found"
microk8s helm3 uninstall postgresql --namespace postgresql || echo "PostgreSQL not found"

echo "=== 🧼 Deleting Kubernetes Namespaces ==="
microk8s kubectl delete namespace mlflow --ignore-not-found
microk8s kubectl delete namespace minio --ignore-not-found
microk8s kubectl delete namespace postgresql --ignore-not-found

echo "=== 🧯 Removing PersistentVolumes and Claims ==="
microk8s kubectl delete pv pv-mlflow pv-minio pv-postgresql --ignore-not-found
microk8s kubectl delete pvc mlflow-pvc -n mlflow --ignore-not-found
microk8s kubectl delete pvc minio-pvc -n minio --ignore-not-found
microk8s kubectl delete pvc postgresql-pvc -n postgresql --ignore-not-found

# echo "=== 🗑 Removing /data directories ==="
# sudo rm -rf /data/mlflow /data/minio /data/postgresql

echo "✅ Cleanup complete. Your system is ready for a fresh deployment."
