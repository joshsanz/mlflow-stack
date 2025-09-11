#!/bin/bash
echo AWS_ACCESS_KEY_ID
kubectl get secret mlflow-secrets -n mlflow -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 -d && echo
echo AWS_SECRET_ACCESS_KEY
kubectl get secret mlflow-secrets -n mlflow -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 -d && echo
