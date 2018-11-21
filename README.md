# virtual_kubernetes_cluster
Vagrant &amp; Ansible files to create a kubernetes cluster on VM's


- debug: var=ansible_default_ipv4.address

[Print all host info]
ansible masters -m setup

hostvars[inventory_hostname]['ansible_default_ipv4']['address']


Play specific role
ansible-playbook site.yml --tags "nfs-client"
