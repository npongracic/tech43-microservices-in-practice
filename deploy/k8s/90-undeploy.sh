#!/usr/bin/env bash
helm uninstall dapr-dashboard --namespace dapr-system
helm uninstall dapr --namespace dapr-system
helm uninstall "kong-ingress" -n kong
kubectl delete namespace kong
helm uninstall redis
helm uninstall kafka-ui
helm uninstall kafka
helm uninstall tech43 -n tech43
kubectl delete namespace tech43