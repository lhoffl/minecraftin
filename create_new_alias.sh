#!/bin/bash

source /home/ubuntu/minecraftin/secret.conf
cp placeholder_alias_record_set.json alias_record_set.json
current_public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
sed -i "s/PLACEHOLDER/$current_public_ip/g" alias_record_set.json
sed -i "s/SERVER/$SERVER/g" alias_record_set.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE --change-batch file://alias_record_set.json
