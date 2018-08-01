#!/bin/sh
echo 'Creating custom network...'
gcloud compute networks create $1 \
--subnet-mode custom \
--bgp-routing-mode global 
echo 'Creating subnet us-central1...'
gcloud compute networks subnets create $2 \
--network $1 \
--region us-central1 \
--range 10.0.0.0/22
echo 'Created'
echo 'Creating subnet us-east1...'
gcloud compute networks subnets create $3 \
--network $1 \
--region us-east1 \
--range 10.0.4.0/22 
echo 'Created'
echo 'Creating firewall rules allowing only quantiphi ip...'
gcloud beta compute firewall-rules create allow-quantiphi-ip-custom \
--network $1 \
--source-ranges 0.0.0.0/0 \
--direction ingress \
--action allow \
--rules tcp:80,tcp:22,tcp:443 \
--priority 1000 \
--target-tags allow-quantiphi-ip-custom
echo 'Firewall Created'

