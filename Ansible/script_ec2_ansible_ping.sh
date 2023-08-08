#!/bin/bash

aws ec2 describe-instances | jq -r '.Reservations[].Instances[].InstanceId' > $(pwd)/instancia_temporal.tmp

for i in $(cat $(pwd)/instancia_temporal.tmp); do
        state=$(aws ec2 describe-instances --instance-id $i | jq -r '.Reservations[].Instances[].State.Name')
        if [[ $state == "running" ]]; then
                aws ec2 describe-instances --instance-id $i | jq -r '.Reservations[].Instances[].PublicIpAddress' >> $(pwd)/ip_instancias_temporal.tmp
        fi
done

for e in $(cat $(pwd)/ip_instancias_temporal.tmp); do
        echo "$e ansible_user=ubuntu ansible_ssh_private_key_file=/home/ag_dev/.ssh/id_rsa" >> $(pwd)/inventario_nuevo.tmp
done

sudo ansible -i $(pwd)/inventario_nuevo.tmp all -m ping
