#!/bin/sh
echo 'Creating Instance Template...'
gcloud compute instance-templates create $1 \
--metadata-from-file startup-script=/home/dharmendra/Desktop/gcp-assignment-automate/assign-2/tomcatinstall.sh
echo 'template created'

echo 'Creating health check'
gcloud compute health-checks create http dharam-health \
--check-interval 5 \
--port 8080 \
--unhealthy-threshold 2 \
--timeout 5 #time in sec to wait before request is considered failure
echo 'Health Check Created'

echo 'creating instance group'
gcloud compute instance-groups managed create $2 \
--template $1 \
--size 1 \
--region us-east1 
echo 'Intsnace Group Created'

echo 'Creating Auto Healing'
gcloud beta compute instance-groups managed set-autohealing $2 \
--initial-delay 300 \
--health-check dharam-health \
--region us-east1
echo 'Auto healing created'

echo 'Create AutoScaling'
gcloud compute instance-groups managed set-autoscaling $2 \
--max-num-replicas 10 \
--min-num-replicas 2 \
--scale-based-on-cpu \
--target-cpu-utilization 0.7 \
--region us-east1 \
--cool-down-period 60
echo 'Auto scaling Created'

echo 'Creating backend services'
gcloud compute backend-services create dhar-backend \
--health-checks dharam-health \
--global
echo 'Backend service created'

echo 'creating backend'
gcloud compute backend-services add-backend dhar-backend \
--instance-group $2 \
--instance-group-region us-east1 \
--global \
--balancing-mode RATE \
--max-rate-per-instance 2
echo 'backend created'

echo 'creating static ip'
gcloud compute addresses create dhar-ip \
--global \
--ip-version IPV4
echo 'Static ip done'

echo 'Creating URL maps'
gcloud compute url-maps create dhar-url-map \
--default-service dhar-backend
echo 'URL map done'

echo 'Creating Target Proxy'
gcloud compute target-http-proxies create dhar-proxy \
--url-map dhar-url-map
echo 'Proxy Done'

echo 'create forwarding rules'
gcloud compute forwarding-rules create dhar-load \
--target-http-proxy dhar-proxy \
--address dhar-ip \
--global \
--ports 8080 
echo 'forward rule created'



