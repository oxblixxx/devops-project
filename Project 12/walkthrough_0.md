The ansible configuration is in this directory, spin up an instance! To serve for our jenkins server and sonarqube server, in further projects we will be automating deployments with terraform setting the architecture as it should be. 

In the ansible-config-management folder, edit the inventory file with the instance spinned up, copy the key file generated and the private key path set in ansible.cfg, copy the public key to `./ssh/authorized_keys` on your server. Then ping the instance with:

```sh
ansible -m ping all
```
Proceed to run the configurations against the server, setting up the frontend, database, sonarqube tasks.

```sh
ansible-playbook  -K root-playbooks/prod.yml
```

