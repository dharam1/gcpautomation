#!/bin/sh
echo 'Creating NAT instance...'
gcloud compute instances create $1 \
--image debian-9-stretch-v20170619 \
--image-project debian-cloud \
--zone us-central1-a \
--can-ip-forward \
--tags allow-quantiphi-ip-custom \
--network dharam-custom \
--subnet dharam-subnet-c \
--metadata-from-file startup-script=/home/dharmendra/Desktop/gcp-assignment-automate/assign-1/nat.sh
echo 'Creating Route...'
gcloud compute routes create private-route \
--destination-range 10.0.0.0/16 \
--next-hop-instance $1 \
--network dharam-custom \
--tags no-ip
echo 'Route Created'
echo 'Creating Private Instance...'
gcloud compute instances create $2 \
--image debian-9-stretch-v20170619 \
--image-project debian-cloud \
--zone us-east1-b \
--no-address \
--tags allow-quantiphi-ip-custom,no-ip \
--network dharam-custom \
--subnet dharam-subnet-e
echo 'Private Instance created'



