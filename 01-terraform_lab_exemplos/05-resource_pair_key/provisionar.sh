#!/bin/bash
terraform init
terraform apply -auto-approve
sleep 10
$(terraform output |grep "ssh -i")