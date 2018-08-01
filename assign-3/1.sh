#!/bin/sh
echo 'Creating topic...'
gcloud pubsub topics create dhar-topic
echo 'topic created'

echo 'creating subscriptions...'
gcloud pubsub subscriptions create dhar-topic-subscription \
--topic dhar-topic
echo 'Subscription done'

echo 'Deploying function...'
gcloud beta functions deploy dhar-func \
--source /home/dharmendra/Desktop/gcp-assignment-automate/assign-3/cldfunc/ \ #even repo url can be mentioned
--runtime nodejs6 \
--entry-point helloPubSub \
--trigger-resource dhar-topic \
--trigger-event google.pubsub.topic.publish
echo 'function deployed'

echo 'Executing function...'
gcloud pubsub topics publish dhar-topic \
--message '{"Name":"dharam-instance-cloud","Size":"n1-standard-1","Sourcebucket":"gs://dharam-storage/IAM.odt"}'
echo 'Function execution done'
