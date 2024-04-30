#!/bin/bash
vms=$(sudo virsh list --all | awk 'NR>2 {print $2}')

for vm in "${vms[@]}"; do
    sudo virsh start "$vm"
done 
