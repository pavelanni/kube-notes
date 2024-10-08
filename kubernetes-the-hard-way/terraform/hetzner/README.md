# Terraform setup for Hetzner Cloud

1. Create a `terraform.vars` file with the following line (use your Hetzner Cloud token for the project you are going to use):

   ```ini
   hcloud_token = "5XN4QXXXXX...XXXX"
   ```

1. Add to this file the variables that you want to change.
You may want to change the following:

   ```none
    hcloud_node_count = # default is 2 (as in the instructions)
    hcloud_location = # default is 'fsn1'; currently (2024-08-11) ARM servers are also available only in 'nbg1' and 'hel1'
    hcloud_server_type = # default is 'cax11', the smallest ARM server with 2 CPU and 4 GB RAM
    hcloud_os_type = # default is Debian 12, as suggested in the instructions
   ```

1. Run `terraform init` and `terraform plan`.
1. Run `terraform apply`. At the end of the output you'll find the Jumpbox's IP address and the location of the private SSH key.
   Use them to test if you can login to the jumpbox host with the following command:

   ```shell
   export JUMPBOX_IP=XX.XX.XX.XX
   ssh -i ./ssh-keys/hcloud-ed25519 -l root $JUMPBOX_IP
   ```

1. Exit from the jumpbox and copy the private SSH key generated by Terraform to the jumpbox:

   ```shell
   scp -i ssh-keys/hcloud-ed25519 ssh-keys/hcloud-ed25519  root@${JUMPBOX_IP}:.ssh/id_ed25519
   ssh -i ./ssh-keys/hcloud-ed25519 -l root ${JUMPBOX_IP} chmod 600 /root/.ssh/id_ed25519
   ```

1. Login to the jumpbox and test if you can login into `server`, `node-0`, and `node-1`:

   ```shell
   ssh -i ./ssh-keys/hcloud-ed25519 -l root $JUMPBOX_IP
   # the following commands you run from the jumpbox
   ssh 10.0.1.3 # server
   exit
   ssh 10.0.1.4 # node-0
   exit
   ssh 10.0.1.5 # node-1
   exit
   ```

1. Your `machines.txt` file should look like this:

   ```none
   10.0.1.3 server.kubernetes.local server
   10.0.1.4 node-0.kubernetes.local node-0 10.200.0.0/24
   10.0.1.5 node-1.kubernetes.local node-1 10.200.1.0/24
   ```

1. Now you are ready to follow the instructions from _Kubernetes The Hard Way_.
