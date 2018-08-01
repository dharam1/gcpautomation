#!/bin/bash
gcloud container clusters create dharam-cluster \
--zone us-east1-b \
--node-locations us-east1-b,us-east1-c,us-east1-d \
--enable-autoscaling --max-nodes 5 --min-nodes 1 \
--labels="name"="dharam","project"="pe-training" \
--num-nodes 2

gcloud container clusters get-credentials dharam-cluster

kubectl run dharam-server --image gcr.io/google-samples/hello-app:1.0 --port 8080 --replicas 5

kubectl expose deployment dharam-server --type LoadBalancer \
--port 3000 --target-port 8080






