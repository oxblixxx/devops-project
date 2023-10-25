## COPYING SSH KEYS TO THE SERVERS

Ansible implements a OPEN-SSH to connect to the slave machines, our IDE will be our master in this project. Meaning to be able to control our slaves we need to have SSH permission.

On your ide terminal generate a ssh-key and add a comment for preference:

```sh
ssh-keygen -C "vsc ansible master key"
```

Create a new user on your `webserver,nfs-server,db-server` setting the same password on this servers.
Ubuntu user doesn't have a password to authenticate with. 

Edit `/etc/ssh/sshd_config` and set `PasswordAuthentication` to yes. 

Ideally you can copy the `.pub` key generated to the `~/.ssh/authorized_keys` file of each server, run:

```sh
ssh-copy-id -i ~/.ssh/<keyname>.pub <username>@<public_ip_address>
```

For clearity it will be like this `ssh-copy-id -i ~/.ssh/ansible.pub oxblixxx@192.89.12.212` . Repeat the process for the rest of the servers by changing the public address and using the same password set. Login to any of the server check if the key is there;

```sh
cat ~/.ssh/authorized_keys
```


