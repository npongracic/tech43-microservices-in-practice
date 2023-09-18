#!/usr/bin/env bash
helm repo add dapr https://dapr.github.io/helm-charts/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install dapr dapr/dapr \
--version=1.11 \
--namespace dapr-system \
--create-namespace \
--wait

helm install redis bitnami/redis --set image.tag=6.2 --set architecture=standalone