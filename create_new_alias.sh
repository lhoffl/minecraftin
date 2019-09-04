#!/bin/bash

cp placeholder_alias_record_set.json alias_record_set.json
current_public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
sed -i "s/PLACEHOLDER/$current_public_ip/g" alias_record_set.json
aws route53 change-resource-record-sets --hosted-zone-id ZWJGID1V5D7BH --change-batch file://alias_record_set.json
