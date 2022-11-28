#!/bin/bash

MACHINE_ID=$(terraform output instance_ip | cut -d '"' -f 2)

PUBLIC_IP=$(aws ec2 describe-instances  --instance-id $MACHINE_ID --query "Reservations[].Instances[].PublicIpAddress" --output text)

echo $PUBLIC_IP