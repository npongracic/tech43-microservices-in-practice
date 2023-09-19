#!/usr/bin/env bash
export REDIS_PASSWORD=$(kubectl get secret --namespace default redis -o jsonpath="{.data.redis-password}" | base64 -d)
echo $REDIS_PASSWORD
kubectl run --namespace default redis-client --restart='Never'  --env REDIS_PASSWORD=$REDIS_PASSWORD  --image docker.io/bitnami/redis:6.2 --command -- sleep infinity

# Use the following command to attach to the pod:
kubectl exec --tty -i redis-client --namespace default -- bash