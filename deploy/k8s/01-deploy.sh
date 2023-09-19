#!/usr/bin/env bash
helm repo add kong https://charts.konghq.com
helm repo add dapr https://dapr.github.io/helm-charts/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts
helm repo update

helm dependency update services/

# install kong
helm upgrade --install -n "kong" --create-namespace --wait --timeout 1m0s kong-ingress -f ./kong/values.yaml kong/kong #--set ingressController.installCRDs=false


helm upgrade --install dapr dapr/dapr \
--version=1.11 \
--namespace dapr-system \
--create-namespace \
--wait

helm install dapr-dashboard dapr/dapr-dashboard --namespace dapr-system

helm install redis bitnami/redis --set image.tag=6.2 --set architecture=standalone

helm install kafka oci://registry-1.docker.io/bitnamicharts/kafka
echo "Installing Kafka UI"
helm install kafka-ui kafka-ui/kafka-ui --version 0.7.5 -f ./kafka-ui/values.yaml

export SERVICE_VERSION="1.0.9"

helm upgrade --install tech43 services/ -n tech43 --create-namespace --wait --timeout 2m0s \
    --set services.chat.serviceImageVersion="$SERVICE_VERSION" \
    --set services.notification.serviceImageVersion="$SERVICE_VERSION" \
    --set services.checkout.serviceImageVersion="$SERVICE_VERSION" \