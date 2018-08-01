#!/bin/sh
echo 'Creating VPC with auto subnet...'
gcloud compute networks create $1 --subnet-mode auto 
echo 'Creating firewall rules allowing only quantiphi ip...'
gcloud beta compute firewall-rules create allow-quantiphi-ip \
--network $1 \
--source-ranges 59.152.52.0/22 \
--direction ingress \
--action allow \
--rules tcp:80,tcp:22,tcp:443 \
--priority 1000 \
--target-tags allow-quantiphi-ip
echo 'Network Created'
